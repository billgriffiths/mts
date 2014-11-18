class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_mts_session_id'

  before_filter :authorize_access, :except => [:get_test, :show_test, :score]

  #  layout proc{ |c| c.request.xhr? ? false : "application" }

  private

  def authorize_access
    return if self.controller_name == 'test_session'
    unless User.find_by_id(session[:user_id])
      session[:orginal_url] = request.original_url
#      flash[:notice] = "Please Log In"
      redirect_to(:controller => "admin", :action => "login") and return false
    end
  end
end