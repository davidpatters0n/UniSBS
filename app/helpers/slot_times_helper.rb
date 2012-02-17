module SlotTimesHelper
  
  
  def disable_remove?(slot_time)
    slot_time.nil? or slot_time.capacity == 0
  end
  
  def enable_remove?(slot_time)
    not disable_remove? slot_time
  end
  
end
