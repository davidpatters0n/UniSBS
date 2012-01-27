class TimeSlotCapacity < ActiveRecord::Base

  belongs_to :site
  has_one :granularity, :through => :site

  validates_presence_of :minutes
  validates_presence_of :site
  validates_presence_of :weekday_capacity
  validates_presence_of :weekend_capacity
  validates_uniqueness_of :minutes, :scope => :site_id

end
