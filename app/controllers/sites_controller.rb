class SitesController < PortalController
  
  before_filter :authorize, :except => [:show]
  before_filter :setup_instance_variables

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def show
    redirect_to diary_diary_day_path(@site, @site.find_today)
  end

  def setup_instance_variables
    @site = Site.find_by_name(params[:id].camelize)
    @main_heading = "Configure #{params[:id].camelize}"
    access_denied unless @site
  end

  def order_template_capacities
    @template_capacities = @site.template_capacities.sort {|a,b| a.minutes <=> b.minutes}
  end

  def preprocess_template_capacity_params
    granularity_minutes = Granularity.find_by_id(params[:site][:granularity_id]).minutes
    Granularity.allowed_minutes.each do |minutes|
      if minutes.modulo(granularity_minutes) == 0
        logger.debug "keep #{minutes}"
      else
        if @site.template_capacities.find_by_minutes(minutes)
          logger.debug "#destroy #{minutes} from site"
          params[:site][:template_capacities_attributes].each{|key, value| value[:_destroy] = '1' if value[:minutes].to_i == minutes }
        else
          logger.debug "#delete #{minutes} from params"
          params[:site][:template_capacities_attributes].delete_if do |key, value|
            value[:minutes].to_i == minutes
          end
        end
      end
    end
    params[:site][:template_capacities_attributes].each do |key, value|
      logger.debug "Template Capacity: #{value.inspect}"
    end
  end

  # GET /admin/:name
  # This is for the site settings
  def edit
    @site.setup_template_capacities
    order_template_capacities
    respond_to { |format| format.html }
  end

  # POST /admin/:name
  # This is for the site settings
  def update

    preprocess_template_capacity_params
          
    if @site.update_attributes(params[:site])

      @site.diary_days.each do |diary_day|
        if diary_day.bookings.count == 0
          diary_day.destroy
        end
      end
      @site.construct_days!

      flash[ :notice ] = "#{params[:id].camelize} reconfigured"
      respond_to { |format| format.html { redirect_to edit_site_path(@site) }}
    else
      order_template_capacities
      respond_to {|format| format.html { render :edit } }
    end
  end

end
