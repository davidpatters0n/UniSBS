class PortalController < ApplicationController

  # The Portal Controller is a shared base class to respond to all
  # user web access (i.e. through html pages)
  # It authenticates the user with devise and provides a standard
  # response (access_denied) for unauthorised access. However
  # authorisation (as opposed to authentication) is the responsibility
  # of the child class: it depends on the object the controller is
  # responsible for.
  # The PortalController is in contrast to the SoaController, responsible
  # for web services.

  before_filter :authenticate_user!

end
