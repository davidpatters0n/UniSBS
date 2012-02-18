class SlotDay < ActiveRecord::Base
  
  belongs_to :site
  has_many :slot_times
  accepts_nested_attributes_for :slot_times
  has_many :bookings, :through => :slot_times
  accepts_nested_attributes_for :bookings
 
  # The day in format YYYYMMDD
  def daystamp
    day.strftime( '%Y-%m-%d' )
  end

  def to_param
    daystamp
  end

  def to_datetime
    DateTime.new(day.year, day.month, day.day)
  end

end
