require "./app/services/validators/password_validator.rb"

class PasswordUpdater
  attr_reader :params, :message, :user

  def initialize(params)
    @params = params
    @message = Hash.new
  end

  def call
    check_token
  end

  private
  
  def check_token
    @user = User.find_by(email: @params[:email])
    if @user
      if @user.reset_password_token.eql? @params[:reset_password_token]
        update_password
      else
        @message[:error] = I18n.t("services.password_updater.token_is_incorrect")
      end
    else
      @message[:error] = I18n.t("services.password_updater.user_not_found")
    end
  end

  def update_password
    if password_format_verification && check_identity_passwords
      if @user.update(password_digest: @params[:new_password])
        @message[:done] = I18n.t("services.password_updater.user_password_successful_updated")
        remove_token
      else
        @message[:error] = I18n.t("services.password_updater.user_password_did_not_update")
      end
    end
  end

  def check_identity_passwords
    unless @params[:new_password].eql? @params[:confirm_new_password]
      @message[:error] = I18n.t("services.password_updater.passwords_do_not_match")
      return false
    end
    true
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

  def remove_token
    @user.reset_password_token = nil
    @user.reset_password_sent_at = nil
    @user.save
  end
end