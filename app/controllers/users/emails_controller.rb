module Users
  class EmailsController < ApplicationController
    before_action :authenticate_user!

    def update
      email_updater = EmailUpdater.new(get_params, get_token)
      email_updater.call
      if email_updater.message[:done]
        render json: { message: email_updater.message[:done] }, status: :ok
      elsif email_updater.message[:error]
        render json: { errors: email_updater.message[:error] }, status: :unprocessable_entity
      end
    end

    private 

    def get_params
      params.require(:user).permit(:update_email_token, :new_email)
    end
  end
end