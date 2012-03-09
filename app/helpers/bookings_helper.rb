module BookingsHelper
  
  def link_to_booking_in_diary(text, booking)
    
    site = booking.site
    slot_day = booking.slot_day
    slot_time = booking.slot_time
    
    # If somehow invalid, we just display the text with no linking
    # No need to check slot_time, it is optional
    if site.nil? or slot_day.nil?
      return text
    end
    
    link_to text, diary_slot_day_time_path(site, slot_day, slot_time), :class => "classname" 
  end
  
end