class SlotTime < ActiveRecord::Base
  
  has_many :bookings
  belongs_to :slot_day
  
  validates :capacity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  
  def number_of_free_slots
    x = capacity - bookings.count
    if x < 0
      0
    else
      x
    end
  end

  def number_of_pallets
    bookings.each.inject(0) do |result, booking|
      if booking.pallets_expected
        result + booking.pallets_expected
      else
        result
      end
    end
  end

end
