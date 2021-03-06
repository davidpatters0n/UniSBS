class Housekeeper::HousekeeperController < ApplicationController

  before_filter :restrict_local

  def check_base_class
    logger.debug "Housekeeper Controller"
  end

  def tip
    logger.debug "Housekeeper has been tipped"
    respond_to do |format|
      format.html { render :text => "Thank you", :status => 200 }
    end
  end

  def endofday
    logger.info "Running end of day housekeeping"
    
    Site.all.each do |site|
      logger.info "End of day for site #{site.name}"
      begin
        site.construct_days!
        site.purge_old_data!
      rescue => e
        logger.error e.message
      end
    end
    respond_to do |format|
      format.html { render :text => "Complete", :status => 200 }
    end
  end

  private

  def restrict_local
    unless request.local?
      logger.debug "Non-local request to housekeeper"
      access_denied
    end
  end

end
