class UserLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_link, only: [:update, :destroy]

  def index
    user_links = UserLink.where(user_id: get_user_id).select(:url, :id)
    if user_links
      render json: { data: user_links }, status: :ok
    else
      render jsin: { data: [] }, status: :no_content
    end
  end

  def create
    user_link_creator = UserLinkCreator.new(user_link_param, get_token)
    user_link_creator.call
    unless user_link_creator.error
      render json: {
        message: I18n.t("controllers.user_links.user_link_was_successful_created")
      }, status: :created
    else
      render json: { errors: user_link_creator.error }, status: :unprocessable_entity
    end
  end

  def update
    user_link_updater = UserLinkUpdater.new(@user_link, get_user_id, user_link_param[:url])
    user_link_updater.call
    unless user_link_updater.error
      render json: { message: I18n.t("controllers.user_links.user_link_was_successful_updated") }, status: :ok
    else
      render json: { error: user_link_updater.error }, status: :unprocessable_entity
    end
  end

  def destroy
    user_link_destroyer = UserLinkDestroyer.new(@user_link, get_user_id)
    user_link_destroyer.call
    unless user_link_destroyer.error
      render json: { message: I18n.t("controllers.user_links.user_link_was_successful_destroyed") }, status: :ok
    else
      render json: { error: user_link_destroyer.error }, status: :unprocessable_entity
    end
  end

  private

  def set_user_link
    @user_link = UserLink.find_by(id: params[:id])
    unless @user_link
      render json: { error: I18n.t("controllers.user_links.user_link_was_not_found") }, status: :not_found
    end
  end

  def user_link_param
    params.require(:user_link).permit(:url)
  end

  def get_user_id
    UserToken.find_by(token: get_token).user_id
  end
end