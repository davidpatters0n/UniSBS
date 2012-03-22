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
      :status => status,
      :pallets_expected => pallets_expected,
      :double_decker => double_decker,
      :live => live,
      :comment => comment})
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
    return false if created_at.nil?
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
      elsif moved
        return 'moved'
      else
        return 'confirmed'
      end
    else
      return 'unknown'
    end
  end

  def check_confirmed_diary_time!(tosite)
    if provisional?
      logger.debug "Not checking diary_time; provisional booking"
      return
    end

    logger.debug "checking diary time for booking"
    nearest_diary_time = tosite.nearest_time!(confirmed_appointment, diary_time)

    if diary_time.nil?
      logger.debug "unexpected, assigning to #{nearest_diary_time.datetime}"
      # don't already have a diary time
      self.diary_time = nearest_diary_time
      self.save!
      log("unexpected")
    end

    if nearest_diary_time != diary_time
      logger.debug "moving from #{diary_time.datetime} to #{nearest_diary_time.datetime}"
      # changing diary time!
      self.diary_time = nearest_diary_time
      self.moved = true
      self.save!
      log("moved")
    end
    
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

