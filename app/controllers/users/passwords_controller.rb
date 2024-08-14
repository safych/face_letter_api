module Users
  class PasswordsController < ApplicationController
    # reset password
    def update
      password_updater = PasswordUpdater.new(get_params)
      password_updater.call
      if password_updater.message[:done]
        render json: { message: password_updater.message[:done] }, status: :ok
      elsif password_updater.message[:error]
        render json: { errors: password_updater.message[:error] }, status: :unprocessable_entity
      end
    end

    private

    def get_params
      params.require(:user).permit(:reset_password_token, :new_password, :confirm_new_password, :email)
    end
  end
end