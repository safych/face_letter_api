class UpdateEmailTokenUpdater
  attr_reader :param, :message, :user, :token

  def initialize(param, token)
    @param = param
    @message = Hash.new
    @token = token
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
        send_token_for_update_email
      else
        @message[:error] = I18n.t("services.update_email_token_updater.user_not_found")
      end
    else
      @message[:error] = I18n.t("services.update_email_token_updater.not_correct_token")
    end
  end

  def send_token_for_update_email
    if current_password_verification
      @user.update_email_token = SecureRandom.hex(3)
      @user.update_email_sent_at = DateTime.now
      if @user.save
        @message[:done] = I18n.t("services.update_email_token_updater.token_was_updated")
        UserMailer.update_email(@user.email, @user.update_email_token).deliver_now
      end
    end
  end

  def current_password_verification
    return true if @user.authenticate(@param[:current_password])
    @message[:error] = I18n.t("services.update_email_token_updater.not_correct_password")
    false
  end
end