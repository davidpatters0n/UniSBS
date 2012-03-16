class SlotDaysController < PortalController

  before_filter :check_site
  def check_site
    @site = Site.find_by_name(params[:diary_id].camelize)
    access_denied if @site.nil?
  end

  def show
    @slot_times = SlotTime.includes(:slot_day).limit(6)
    session[:booking_context] = 'diary'

    # The route passes in the 'daystamp' which is in the form YYYYMMDD:
    daystamp = params[:id]
    @slot_day = @site.find_day daystamp

    if @slot_day.nil?
      # Redirect to today if day isn't available
      @slot_day = @site.find_today

      if @slot_day.nil?
      flash[:error] = "Couldn't find day #{daystamp} or today"
      redirect_to :root
      else
      flash[:error] = "Day '#{daystamp}' unavailable"
      redirect_to diary_slot_day_path(@site, @slot_day)
      end
    else
    @main_heading = "#{@site.name} #{@slot_day.day.strftime('%A %e %B %Y')}"
    end

    # we might want to show slot times just before/after so we use instance variable:
    if @slot_day
    @slot_times = @slot_day.slot_times
    end

    datetime = @slot_day.day.to_datetime

    @slot_times.each do |slot_time|
      new_booking = slot_time.bookings.build(
      :company => current_user.company,
      :provisional_appointment => datetime + slot_time.time_slot.minutes)
      logger.debug new_booking.inspect
    end

  end

  def add_slot
    logger.debug "Adding slot"
    @slot_time = SlotTime.find_by_id(params[:slot_time_id])
    begin
    @slot_time.capacity += 1
      @slot_time.save!
    rescue => e
    logger.error "Failed to add slot to slot time: #{e.message}"
    end
  end

  def remove_slot
    logger.debug "Removing slot"
    @slot_time = SlotTime.find_by_id(params[:slot_time_id])
    begin
    @slot_time.capacity -= 1
      @slot_time.save!
    rescue => e
    logger.error "Failed to remove slot from slot time: #{e.message}"
    end
  end

  def set_capacity
    logger.debug "Setting capacity"
    @slot_time = SlotTime.find_by_id(params[:slot_time_id])
    begin
      @slot_time.capacity = params[:slot_time][:capacity]
      @slot_time.save!
    rescue => e
    logger.error "Failed to set capacity for slot time: #{e.message}"
    end

    @slot_time = SlotTime.find_by_id params[:slot_time_id]
    @slot_day = @slot_time.slot_day
    redirect_to diary_slot_day_path(@site, @slot_day)
  end

end
