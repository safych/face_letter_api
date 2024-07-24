class UserLinksController < ApplicationController
  before_action :set_user_link only: [:update, :destroy]

  def index

  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def set_user_link
    @user_link = UserLink.find(params[:id])
  end
end