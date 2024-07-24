class UserTokensController < ApplicationController
  before_action :set_user_token, only: [:destroy]

  def create

  end

  def destroy

  end

  private

  def set_user_token
    @user_token = UserToken.find(params[:id])
  end
end