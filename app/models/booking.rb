class Booking < ActiveRecord::Base

#  include FilterScope

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
  
#  def self.search(search = nil)
#  if search
#    s = "%#{params[:s]}%"
#    where('name LIKE ? OR company LIKE ? OR site LIKE ?' [s, s, s])
 # else
#    self
#  end
#end
end 
