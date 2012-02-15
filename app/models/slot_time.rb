class SlotTime < ActiveRecord::Base
  
  has_many :bookings
  belongs_to :slot_day
  
end
