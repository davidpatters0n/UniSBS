class Site < ActiveRecord::Base

  belongs_to :granularity
  belongs_to :booking
  belongs_to :company

  has_many :slot_days
  has_many :time_slot_capacities, :order => "minutes"
  accepts_nested_attributes_for :time_slot_capacities, :allow_destroy => true
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :granularity

  validates :past_days_to_keep, :numericality => {
    :only_integer => true,
    :greater_than => 0}
  validates :days_in_advance, :numericality => {
    :only_integer => true,
    :greater_than => 0}
  validates :provisional_bookings_expire_after, :numericality => {
    :only_integer => true,
    :greater_than => 0}

  # Everything except the name should be modifiable by global admin:
  attr_protected :name
  
  
  after_create   {|record| log("create")}
  after_update   {|record| log("update")}
  before_destroy {|record| log("delete")}

  def log(logclass_name)
    SiteLogentry.create({
      :logclass_name => logclass_name,
      :site_id => id,
      :company => company,
      :booking => booking,
      :name => name,
      :past_days_to_keep => past_days_to_keep,
      :days_in_advance => days_in_advance,
      :provisional_bookings_expire_after => provisional_bookings_expire_after,
      :granularity => granularity_minutes})
  end


  def self.names
    ['Cannock', 'Doncaster']
  end

  def to_param
    name.camelize
  end

  def find_day(daystamp)
    slot_days.find(:first, :conditions => ["DATE(day)=?", daystamp])
  end

  def find_today
    find_day Date.today
  end

  def find_yesterday
    find_day Date.yesterday
  end
  
  def find_tomorrow
    find_day Date.tomorrow
  end

  # Builds time slot capacities at every possible time for use in the controller 
  def setup_time_slot_capacities
    Granularity.allowed_minutes.each do |minutes|
      unless time_slot_capacities.find_by_minutes(minutes)
        tsc = time_slot_capacities.build(:minutes=>minutes, :weekday_capacity=>0, :weekend_capacity=>0)
      end
    end
  end

  # Creates time slot capacities with some default values, for first use 
  def construct_initial_time_slot_capacities!
    granularity.times.each do |minutes|
      tsc = TimeSlotCapacity.find_or_create_by_site_id_and_minutes(id, minutes)
      raise "Could not construct time slot capacity" if tsc.nil?
      # We put in some non-zero values just to allow things to function by default:
      tsc.update_attributes!(:weekday_capacity => 3, :weekend_capacity => 2)
    end
  end

  # Creates a slot_day associated with this site, and based on its configuration
  def construct_day!(day)
    slot_day = SlotDay.find_or_create_by_site_id_and_day(:site_id => id, :day => day.beginning_of_day)
    time_slot_capacities.each do |time_slot_capacity|
      slot_time = SlotTime.find_or_create_by_slot_day_id_and_time_slot(:slot_day_id => slot_day.id, :time_slot => time_slot_capacity.minutes)
      raise "Could not find or create slot day" if slot_time.nil?
      if day.saturday? or day.sunday?
        slot_time.capacity = time_slot_capacity.weekend_capacity
      else
        slot_time.capacity = time_slot_capacity.weekday_capacity
      end
      slot_time.save!
    end
  end

  def days_available_until
    i = 0
    while true 
      day = Date.today + i
      return day unless find_day(day)
      i += 1
    end
  end

  def construct_days!
    for i in (0..days_in_advance)
      day = Date.today + i
      unless find_day(day)
        logger.info "Constructing day #{day} for site #{name}..."
        construct_day! day
      end
    end
  end

end
