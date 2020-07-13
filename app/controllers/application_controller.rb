class ApplicationController < ActionController::Base
  before_action :set_user
  before_action :ensure_user

  private

  def set_user
    @current_user = User.find_by_id(session[:user_id])
  end

  def ensure_user
    redirect_to new_user_path unless @current_user
  end
end
