module Users
  class RegistrationsController < ApplicationController
    def create
      user = User.new(registrations_params)
      registration_creator = RegistrationCreator.new(user)
      registration_creator.call
      if user.errors.empty?
        render json: { data: user.user_token.last.token, 
        message: I18n.t("controllers.registrations.successful_sign_up") }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def registrations_params
      params.require(:user).permit(:name, :surname, :email, :password)
    end
  end
end