class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_base_class, :unless => :devise_controller?
  before_filter :set_cache_buster

  def check_base_class
    raise "Not allowing direct use of ApplicationContoller as parent class"
  end

  # avoid caching
  def set_cache_buster
    response.headers["Cache-Control"] =
         "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # Access denied is indistinguisable to the user from a routing error,
  # which comes through the errors#routing path (see ErrorsController).
  # This is nicely secure because it doesn't hint that something is even
  # there that they can't access. In development mode, however, we be
  # a bit more helpful
  def access_denied
    if Rails.env.development?
      if params[:a]
        msg = "Path '#{params[:a]}' not found"
      else
        msg = "Access denied"
      end
    else
      msg = "Sorry, that is not accessible or does not exist"
    end

    redirect_to :root, :alert => msg
  end

end
