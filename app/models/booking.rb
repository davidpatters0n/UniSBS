class Booking < ActiveRecord::Base

  include FilterScope

  belongs_to :site
  belongs_to :company
  belongs_to :diary_time 

  validates_presence_of :company
  validates_presence_of :reference_number
  validates_uniqueness_of :reference_number, :scope => :company_id

  after_create   {|record| log("create")}
  after_update   {|record| log("update")}
  before_destroy {|record| log("delete")}

  def company_name
    if company.nil?
      nil
    else
      company.name
    end
  end

  def log(logclass_name)
    BookingLogentry.create({
      :logclass_name => logclass_name,
      :booking_id => id,
      :site => site,
      :company => company_name,
      :reference_number => reference_number,
      :provisional_appointment => provisional_appointment,
      :confirmed_appointment => confirmed_appointment,
      :pallets_expected => pallets_expected})
  end

  def diary_day
    diary_time.diary_day if diary_time
  end

  def site
    diary_day.site if diary_day
  end
 
  def provisional?
    confirmed_appointment.nil?
  end

  def confirmed?
    not confirmed_appointment.nil?
  end

  def expired?
    return false if site.nil?
    return false if provisional_appointment.nil?
    provisional? and Time.now > (created_at + site.provisional_bookings_expire_after.minutes)
  end

  def status
    if confirmed_appointment.nil? and provisional_appointment.nil?
      return 'unknown'
    elsif expired?
      return 'expired'
    elsif provisional?
      return 'provisional'
    elsif confirmed?
      if provisional_appointment.nil?
        return 'unexpected'
      else
        return 'confirmed'
      end
    else
      return 'unknown'
    end
  end

  def best_diary_time!
    nearest_diary_time = site.nearest_time!(confirmed_appointment, diary_time)
    if diary_time
      # don't already ahve a diary time

    if nearest_diary_time != diary_time
      # changing diary time!
    end
  end

  def update_slot!
    return if provisional?
  end

  def slots_taken_up
    if expired?
      0
    elsif double_decker
      2
    elsif reference_number
      1
    else
      0
    end
  end

end

