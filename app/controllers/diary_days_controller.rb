class DiaryDaysController < PortalController

  before_filter :check_site
  def check_site
    @site = Site.find_by_name(params[:diary_id].camelize)
    access_denied if @site.nil?
  end

  def show
    @diary_times = DiaryTime.includes(:diary_day).limit(6)
    session[:booking_context] = 'diary'

    # The route passes in the 'daystamp' which is in the form YYYYMMDD:
    daystamp = params[:id]
    @diary_day = @site.find_day daystamp

    if @diary_day.nil?
      # Redirect to today if day isn't available
      @diary_day = @site.find_today

      if @diary_day.nil?
      flash[:error] = "Couldn't find day #{daystamp} or today"
      redirect_to :root
      else
      flash[:error] = "Day '#{daystamp}' unavailable"
      redirect_to diary_diary_day_path(@site, @diary_day)
      end
    else
    @main_heading = "#{@site.name} #{@diary_day.day.strftime('%A %e %B %Y')}"
    end

    # we might want to show slot times just before/after so we use instance variable:
    if @diary_day
    @diary_times = @diary_day.diary_times
    end

    datetime = @diary_day.day.to_datetime

    @diary_times.each do |diary_time|
      new_booking = diary_time.bookings.build(
      :company => current_user.company,
      :provisional_appointment => datetime + diary_time.time_slot.minutes)
      logger.debug new_booking.inspect
    end

  end

  def add_slot
    logger.debug "Adding slot"
    @diary_time = DiaryTime.find_by_id(params[:diary_time_id])
    begin
    @diary_time.capacity += 1
      @diary_time.save!
    rescue => e
      logger.error "Failed to add slot to slot time: #{e.message}"
      render :nothing => true
    end
  end

  def remove_slot
    logger.debug "Removing slot"
    @diary_time = DiaryTime.find_by_id(params[:diary_time_id])
    begin
      @diary_time.capacity -= 1
      @diary_time.save!
    rescue => e
      logger.error "Failed to remove slot from slot time: #{e.message}"
      render :nothing => true
    end
  end

  def set_capacity
    logger.debug "Setting capacity"
    @diary_time = DiaryTime.find_by_id(params[:diary_time_id])
    begin
      @diary_time.capacity = params[:diary_time][:capacity]
      @diary_time.save!
    rescue => e
     flash[:alert] = "Could not change capacity because #{e.message}"
    end

    @diary_time = DiaryTime.find_by_id params[:diary_time_id]
    @diary_day = @diary_time.diary_day
    redirect_to diary_diary_day_path(@site, @diary_day)
  end

end
