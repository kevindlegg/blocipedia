class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  
  private
  def after_sign_in_path_for(resource)
    wikis_path
  end

  def require_sign_in
    unless current_user
      flash[:alert] = "You must be logged in to do that"
      redirect_to new_user_session_path
    end
  end
end
