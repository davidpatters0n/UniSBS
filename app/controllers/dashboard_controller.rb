class DashboardController < PortalController

  def index
    @main_heading = "Dashboard"
  end
  
  def admin
    @main_heading = "Portal Administration"
  end

  def logs
    @main_heading = "Transaction Logs"
  end

  def search
    @result = nil

    respond_to do |format|
      format.html do
        if @result.nil?
          redirect_to(:root, :error => 'No records found')
        else
          redirect_to(@result)
        end
      end
      format.js
    end
  end

end
