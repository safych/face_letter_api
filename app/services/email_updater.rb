require "./app/services/validators/email_validator.rb"

class EmailUpdater
  attr_reader :params, :message, :user, :token

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
        check_token
      else
        @message[:error] = I18n.t("services.email_updater.user_not_found")
      end
    else
      @message[:error] = I18n.t("services.email_updater.not_correct_token")
    end
  end

  def check_token
    if @user.update_email_token.eql? @params[:update_email_token]
      update_email
    else
      @message[:error] = I18n.t("services.email_updater.token_for_update_email_is_incorrect")
    end
  end

  def update_email
    if email_format_verification
      if @user.update(email: @params[:new_email])
        @message[:done] = I18n.t("services.email_updater.user_email_successful_updated")
        remove_token
      else
        @message[:error] = I18n.t("services.email_updater.user_email_did_not_update")
      end
    end
  end

  def email_format_verification
    error_text = ""
    email_validator = EmailValidator.new(@params[:new_email])
    unless email_validator.valid?
      email_validator.errors.full_messages.each do |message|
        error_text += "#{message}. "
      end
      @message[:error] = error_text
      return false
    end
    true
  end
  
  def remove_token
    @user.update_email_token = nil
    @user.update_email_sent_at = nil
    @user.save
  end
end