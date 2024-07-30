class ApplicationController < ActionController::API
  def authenticate_user!
    token_checker = TokenChecker.new(get_token)
    token_checker.call
    unless token_checker.status
      render json: { error: I18n.t("controllers.application.unauthorized") }, status: :unauthorized
    end
  end

  private

  def get_token
    request.headers["Authorization"]&.split(' ')&.last
  end
end
