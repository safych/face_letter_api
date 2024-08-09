require "./app/services/validators/password_validatior.rb"

class UserUpdater
  attr_reader :params, :token, :message, :user

  def initialize(params, token)
    @params = params
    @token = token
    @message = Hash.new
  end

  def call
    search_user_by_token
  end

  private

  def search_user_by_token
    user_token = UserToken.find_by(token: @token)
    if user_token
      @user = User.find(user_token.user_id)
      if @user
        update
      else
        @message[:error] = I18n.t("services.user_updater.user_not_found")
      end
    else
      @message[:error] = I18n.t("services.user_updater.not_correct_token")
    end
  end

  def update
    if @params[:name] || @params[:surname]
      update_name_surname
    elsif @params[:new_password]
      update_password
    end
  end

  def update_name_surname
    if @user.update(name: @params[:name], surname: @params[:surname])
      @message[:done] = I18n.t("services.user_updater.user_data_successful_updated")
    else
      @message[:error] = I18n.t("services.user_updater.user_data_did_not_update")
    end
  end

  def update_password
    if password_format_verification && current_password_verification
      if @user.update(password_digest: @params[:new_password])
        @message[:done] = I18n.t("services.user_updater.user_password_successful_updated")
      else
        @message[:error] = I18n.t("services.user_updater.user_password_did_not_update")
      end
    end
  end

  def password_format_verification
    error_text = ""
    password_validator = PasswordValidator.new(@params[:new_password])
    unless password_validator.valid?
      password_validator.errors.full_messages.each do |message|
        error_text += "#{message}. "
      end
      @message[:error] = error_text
      return false
    end
    true
  end

  def current_password_verification
    return true if @user.authenticate(@params[:current_password])
    @message[:error] = I18n.t("services.user_updater.not_correct_password")
    false
  end
end