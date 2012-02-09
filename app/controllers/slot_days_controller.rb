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
    day = nil

    # get the slot day
    @slot_day = SlotDay.find_by_site_id_and_day(@site.id, day)

    if @slot_day.nil?
       flash[ :notice ] = "TODO - Going to a day that doesn't exist should redirect to today"
    end

  end

end
