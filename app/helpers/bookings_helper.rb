module BookingsHelper
  
  def link_to_booking_in_diary(text, booking)
    
    site = booking.site
    diary_day = booking.diary_day
    diary_time = booking.diary_time
    
    # If somehow invalid, we just display the text with no linking
    # No need to check diary_time, it is optional
    if site.nil? or diary_day.nil?
      return text
    end
    
    link_to text, diary_diary_day_time_path(site, diary_day, diary_time), :class => "classname" 
  end
  
end
