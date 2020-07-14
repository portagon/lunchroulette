class UsersController < ApplicationController
  skip_before_action :ensure_user

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_create_by(email: params.dig(:user, :email).downcase.strip)
    if @user.valid?
      UserMailer.login_mail(@user).deliver_later
      flash.now[:notice] = 'We\'ve sent you a login link, please check your email inbox'
    end
    render :new
  end

  def login
    if user = GlobalID::Locator.locate_signed(params[:id])
      session[:user_id] = user.id
      redirect_to params[:redirect] || root_path
    else
      redirect_to new_user_path
    end
  end
end
