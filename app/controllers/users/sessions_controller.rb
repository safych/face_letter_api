module Users
  class SessionsController < ApplicationController
    before_action :set_user_token, only: :destroy

    def create
      session_creator = SessionCreator.new(sessions_params)
      session_creator.call
      if session_creator.token
        UserToken.new(user_id: session_creator.user.id, token: session_creator.token).save
        render json: { data: session_creator.token, 
        message: I18n.t("controllers.sessions.successful_sign_in") }, status: :created
      else
        render json: { error: session_creator.error }, status: :unauthorized
      end
    end

    def destroy
      if @user_token
        @user_token.destroy
        render json: { message: I18n.t("controllers.sessions.successful_exit_from_the_account") }, status: :ok
      else
        render json: { error: I18n.t("controllers.sessions.unsuccessful_exit_from_the_account") }, status: :unprocessable_entity
      end
    end

    private

    def set_user_token
      @user_token = UserToken.find_by(token: get_token)
    end

    def sessions_params
      params.require(:user).permit(:email, :password)
    end
  end
end