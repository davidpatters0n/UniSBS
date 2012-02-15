class ControlpanelController < PortalController
  
  before_filter :authorize

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def restart_housekeeper
    if HousekeeperDaemonControl.restart
      @result = "Daemon restarted"
    else
      @result = "Could not restart daemon"
    end
  end

  def show
    @main_heading = 'Control Panel'
    @soa = Soa.find(:first)
  end

end
