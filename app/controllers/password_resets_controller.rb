class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params.dig(:password_reset, :email)&.downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".send_pass_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t ".invalid_email"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".empty_password")
      render :edit
    elsif @user.update(user_params)
      update_success @user
    else
      flash.now[:danger] = t ".reset_failed"
      render :edit
    end
  end

  def edit; end

  private

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".user_activate"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_reset_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def update_success user
    log_in user
    flash[:success] = t ".reset_successful"
    redirect_to user
  end
end
