class Booking < ActiveRecord::Base

  belongs_to :site
  belongs_to :company
  belongs_to :slot_time 

  validates_presence_of :company
  validate :validate_external_company
  validates_presence_of :reference_number
  validates_uniqueness_of :reference_number, :scope => :company_id

  def validate_external_company
    if not company.nil? and company.is_internal?
      errors.add(:company, "cannot be internal")
    end
  end

  def site
    if slot_time and slot_time.slot_day
      slot_time.slot_day.site
    else
      nil
    end
  end

end
