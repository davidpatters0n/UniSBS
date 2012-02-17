class ErrorsController < PortalController
 
  # We make a bad route indistinguishable from an inaccessible resource for
  # security reasons, see ApplicationController.access_denied method.
  def routing
    access_denied
  end

end

