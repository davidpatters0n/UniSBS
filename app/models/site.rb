class Site < ActiveRecord::Base

  belongs_to :granularity

  has_many :time_slot_capacities
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

  def self.names
    ['Cannock', 'Doncaster']
  end

  def to_param
    name.camelize
  end

  def setup_time_slot_capacities
    (0..(24*60 - 1)).each do |minutes|
      if minutes % 5 == 0 and not time_slot_capacities.find_by_minutes(minutes)
        tsc = time_slot_capacities.build(:minutes=>minutes, :weekend_capacity=>0, :weekday_capacity=>0)
      end
    end
  end



end
