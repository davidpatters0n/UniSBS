class ControlpanelController < PortalController
  
  before_filter :authorize

  def authorize
    access_denied unless current_user.is_global_admin?  
  end

  def show
    @main_heading = 'Control Panel'
    @soa = Soa.find(:first)
  end
  
  def restart_housekeeper
    if HousekeeperDaemonControl.restart
      flash[:notice] = 'Daemon restarted'
    else
      flash[:alert] = 'Could not restart daemon'
    end
    redirect_to :controlpanel
  end

end
