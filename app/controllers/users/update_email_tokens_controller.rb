module Users
  class UpdateEmailTokensController < ApplicationController
    before_action :authenticate_user!

    def update
      update_email_token_creator = UpdateEmailTokenCreator.new(get_param, get_token)
      update_email_token_creator.call
      if update_email_token_creator.message[:done]
        render json: { message: update_email_token_creator.message[:done] }, status: :ok
      elsif update_email_token_creator.message[:error]
        render json: { errors: update_email_token_creator.message[:error] }, status: :unprocessable_entity
      end
    end

    private

    def get_param
      params.require(:user).permit(:current_password)
    end
  end
end