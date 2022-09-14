class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".micropost_created_success"
      redirect_to root_url
    else
      flash.new[:danger] = t ".micropost_created_fail"
      @pagy, @feed_items = pagy current_user.feed, items: Settings.pagy.page_10
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".micropost_deleted_success"
    else
      flash[:danger] = t ".micropost_deleted_fail"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]

    return if @micropost

    flash[:danger] = t ".micropost_invalid"
    redirect_to request.referer || root_url
  end
end
