class Soa::ErrorsController < Soa::SoaController

  def routing
    respond_to do |format|
      format.html { render :text => "Path '#{params[:a]}' not found", :status => 404 }
    end
  end

end
