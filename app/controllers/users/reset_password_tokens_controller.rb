module Users
  class ResetPasswordTokensController < ApplicationController
    def update
      reset_password_token_updater = ResetPasswordTokenUpdater.new(get_param)
      reset_password_token_updater.call
      if reset_password_token_updater.message[:done]
        render json: { message: reset_password_token_updater.message[:done] }, status: :ok
      elsif reset_password_token_updater.message[:error]
        render json: { errors: reset_password_token_updater.message[:error] }, status: :unprocessable_entity
      end
    end

    private

    def get_param
      params.require(:user).permit(:email)
    end
  end
end