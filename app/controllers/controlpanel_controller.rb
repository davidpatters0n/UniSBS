class ControlpanelController < PortalController
  
  before_filter :authorize

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def restart_housekeeper
    HousekeeperDaemonControl.restart
  end

  def show
    @main_heading = 'Control Panel'
  end

end
