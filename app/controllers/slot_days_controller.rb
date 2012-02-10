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

  end

end
