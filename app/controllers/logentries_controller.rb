class LogentriesController < PortalController
  
  before_filter :authorise

  def authorise
    current_user.is_booking_manager?
  end

  def show
    @logentry = Logentry.find_by_id(params[:id])
    @main_heading = 'Log Entry'
  end

  # GET /bookings
  # GET /bookings.json
  def index
    @main_heading = 'Log Enties'
  end

end
