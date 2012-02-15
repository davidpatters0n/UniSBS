class SlotDay < ActiveRecord::Base
  
  belongs_to :site
  has_many :slot_times
  accepts_nested_attributes_for :slot_times
 
  # The day in format YYYYMMDD
  def daystamp
    day.strftime( '%Y-%m-%d' )
  end

  def to_param
    daystamp
  end

end
