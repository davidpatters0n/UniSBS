class SlotDaysController < PortalController

  before_filter :check_site

  def check_site
    @site = Site.find_by_name(params[:diary_id].camelize)
    access_denied if @site.nil?
  end

  def show
    # The route passes in the 'daystamp' which is in the form YYYYMMDD:
    daystamp = params[:id]

    # TODO - we need to convert the daystamp back into the day:datetime attribute

    # get the slot day
    #@slot_day = SlotDay.find(:first, :conditions => ["site_id=? and DATE(day)=?", @site.id, daystamp])
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
  
  
  
  def create 
    #TODO 
    #Need transfer a day and a time and a capacity for creation
    @slot_day = SlotDay.new(:day=>params[:day])
    #create slot_time
    @slot_day.slot_times << SlotTime.new(:time_slot=>params[:time],:capacity=>params[:capacity]);
    @slot_day.save
  end

 def update 
  @slot_day = SlotDay.find(params[:id])
  @slot_time = @slot_day.slot_times.find_by_time_slot(params[:time_slot])
  if @slot_time.nil?
    #add slot time
    @slot_time = SlotTime.new(:time_slot=>params[:time_slot],:capacity=>params[:capacity]);
    @slot_time.slot_day_id = params[:id]
  else
    #set slot time
    @slot_time = @slot_time[0]
  end if
  @slot_time.capacity = params[:capacity]
  @slot_time.save

 end
end
