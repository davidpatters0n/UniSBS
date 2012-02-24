module SlotDaysHelper

  def diary_slot_day_time_path(site, slot_day, slot_time=nil)
    
    if slot_time
      diary_slot_day_path(site, slot_day) + "#slot_time#{slot_time.id}"
    else
      diary_slot_day_path(site, slot_day)
    end
    
  end

end
