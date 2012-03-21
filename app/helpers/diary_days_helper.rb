module DiaryDaysHelper

  def diary_diary_day_time_path(site, diary_day, diary_time=nil)
    
    if diary_time
      diary_diary_day_path(site, diary_day) + "#diary_time#{diary_time.id}"
    else
      diary_diary_day_path(site, diary_day)
    end
    
  end

end
