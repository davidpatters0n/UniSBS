module DiaryTimesHelper
  
  
  def disable_remove?(diary_time)
    diary_time.nil? or diary_time.capacity == 0
  end
  
  def enable_remove?(diary_time)
    not disable_remove? diary_time
  end
  
end
