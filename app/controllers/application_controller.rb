class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pagy::Backend
  include SessionsHelper
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".logged_in"
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_invalid"
    redirect_to root_url
  end
end
