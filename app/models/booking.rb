class Booking < ActiveRecord::Base

  belongs_to :site
  belongs_to :company
  belongs_to :slot_time 

  validates_presence_of :company
  validate :validate_external_company
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

  def validate_external_company
    if not company.nil? and company.is_internal?
      errors.add(:company, "cannot be internal")
    end
  end

  def slot_day
    slot_time.slot_day if slot_time
  end

  def site
    slot_day.site if slot_day
  end

  def provisional?
    confirmed_appointment.nil?
  end

  def confirmed?
    not confirmed_appointment.nil?
  end

  def expired?
    false
    #provisional? and Time.now > (provisional_appointment + site.provisional_bookings_expire_after.minutes)
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

  def update_slot!
  end

end
