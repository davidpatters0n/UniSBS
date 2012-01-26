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
    respond_to { |format| format.html }
  end

  # POST /admin/:name
  # This is for the site settings
  def update
   
    if @site.update_attributes(params[:site])
      flash[ :notice ] = "#{params[:id].camelize} reconfigured" 
    end

    respond_to {|format| format.html { render :edit } }
  end

end
