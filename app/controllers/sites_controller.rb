class SitesController < PortalController
  
  before_filter :authorize
  before_filter :setup_instance_variables

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def setup_instance_variables
    @site = Site.find_by_name(params[:id].camelize)
    @main_heading = "Configure #{params[:id].camelize}"
    access_denied unless @site
  end

  # GET /admin/:name
  # This is for the site settings
  def edit
    @site.setup_time_slot_capacities
    @time_slot_capacities = @site.time_slot_capacities.sort {|a,b| a.minutes <=> b.minutes}
    respond_to { |format| format.html }
  end

  # POST /admin/:name
  # This is for the site settings
  def update

    granularity_minutes = Granularity.find_by_id(params[:site][:granularity_id]).minutes
    (0..(1440-1)).each do |minutes|
      if minutes.modulo(granularity_minutes) == 0
        logger.debug "keep #{minutes}"
      else
        if @site.time_slot_capacities.find_by_minutes(minutes)
          logger.debug "#destroy #{minutes} from site"
          params[:site][:time_slot_capacities_attributes].each{|key, value| value[:_destroy] = '1' if value[:minutes].to_i == minutes }
        else
          logger.debug "#delete #{minutes} from params"
          params[:site][:time_slot_capacities_attributes].delete_if do |key, value|
            value[:minutes].to_i == minutes
          end
        end
      end
    end
    params[:site][:time_slot_capacities_attributes].each do |key, value|
      logger.debug "Time Slot Capacity: #{value.inspect}"
    end
          
    if @site.update_attributes(params[:site])
      flash[ :notice ] = "#{params[:id].camelize} reconfigured"
      logger.debug "#{params[:id].camelize} reconfigured with #{params[:site].inspect}"
      respond_to { |format| format.html { redirect_to edit_site_path(@site) }}
    else
      logger.debug "Did not configure #{params[:id].camelize}"
      respond_to {|format| format.html { render :edit } }
    end
  end

end
