class SlotDaysController < PortalController

  before_filter :check_site

  def check_site
    @site = Site.find_by_name(params[:diary_id].camelize)
    access_denied if @site.nil?
  end

  def show
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
      @main_heading = "#{@site.name} #{l @slot_day.day}"
    end

    # we might want to show slot times just before/after so we use instance variable:
    if @slot_day
      @slot_times = @slot_day.slot_times
    end
    
    if current_user.is_booking_manager?
      @bookings = @slot_day.bookings
    else
      # TODO filter bookings by transport user's company
      #@bookings = @slot_day.bookings.find
    end

    @slot_times.each do |slot_time|
      new_booking = slot_time.bookings.build
      new_booking.slot_time_id = slot_time.id
      new_booking.company_id = current_user.company.id
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

    #render :template=>"slot_days/set_capacity.js.erb"
    @slot_time = SlotTime.find_by_id params[:slot_time_id]
    @slot_day = @slot_time.slot_day
    redirect_to diary_slot_day_path(@site, @slot_day)
  end

end
