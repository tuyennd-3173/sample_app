class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # binding.pry
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".account_active_tit"
      redirect_to login_path
    else
      flash[:danger] = t ".account_active_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
