module LogentriesHelper

  def logtype(logentry)
    logentry.loggable_type.gsub(/Logentry/, "") unless logentry.loggable_type.nil? 
  end

end
