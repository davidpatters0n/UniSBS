class TimeSlotCapacity < ActiveRecord::Base

  belongs_to :site

  validates_presence_of :minutes
  validates_presence_of :site
  validates_presence_of :weekday_capacity
  validates_presence_of :weekend_capacity
  validates_uniqueness_of :minutes, :scope => :site_id
  validates :minutes, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => 24*60 }
  validates :weekday_capacity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  validates :weekend_capacity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  validate :multiple_of_five_minutes

  def multiple_of_five_minutes
    if minutes.modulo(5) > 0
      errors.add(:minutes, "#{minutes} not a multiple of 5 minutes")
    end
  end

end
