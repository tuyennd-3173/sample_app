class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.pagy.page_10)
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

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_eror"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to users_path
  endaccess

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".logged_in"
    redirect_to login_url
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_invalid"
    redirect_to root_url
  end

  def correct_user
    return if current_user? @user

    flash[:error] = t ".user_edit_fail"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
