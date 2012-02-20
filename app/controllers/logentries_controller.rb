class LogentriesController < PortalController
  
  before_filter :authorise

  def authorise
    current_user.is_booking_manager?
  end

  def show
    @logentry = Logentry.find_by_id(params[:id])
    @loggable = @logentry.loggable
    @main_heading = 'Log Entry'
  end

  # GET /bookings
  def index
    if params[:id].nil?
      @main_heading = 'Log Entries'
      @logentries = Logentry.all
    else
      @index_log_type  = params[:id].classify
      modelname = "#{@index_log_type}Logentry"
      @main_heading = "#{@index_log_type} Log"
      @logentries = Logentry.where("loggable_type = ?", modelname)
      @klass = modelname.constantize
    end
  end

end
