class DiaryTime < ActiveRecord::Base
  
  has_many :bookings
  accepts_nested_attributes_for :bookings
  belongs_to :diary_day
  
  validates_presence_of :diary_day
  validates :capacity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
 
  def bookings_visible_to(user)
    if user.is_booking_manager?
      bookings
    else
      Booking.where(:diary_time_id => id, :company_id => user.company.id)
    end
  end

  def number_of_slots_taken
    bookings.inject(0) {|total, booking| total + booking.slots_taken_up}
  end

  def number_of_free_slots
    if capacity.nil?
      return 0
    end
    x = capacity - number_of_slots_taken
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

  def datetime
    dt = diary_day.day.to_datetime
    return dt + time_slot.minutes
  end

end
