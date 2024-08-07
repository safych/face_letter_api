class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    user_updater = UserUpdater.new(user_params, get_token)
    user_updater.call
    if user_updater.message[:done]
      render json: { message: user_updater.message[:done] }, status: :ok
    else
      render json: { error: user_updater.message[:error] }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:new_password, :current_password, :name, :surname)
  end
end