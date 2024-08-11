class ResetPasswordTokenUpdater
  attr_reader :param, :message, :user

  def initialize(param)
    @param = param
    @message = Hash.new
  end

  def call
    search_user_by_email
  end

  private

  def search_user_by_email
    @user = User.find_by(email: @param[:email])
    if @user
      send_token_for_reset_password
    else
      @message[:error] = I18n.t("services.reset_password_token_updater.user_not_found")
    end
  end

  def send_token_for_reset_password
    @user.reset_password_token = SecureRandom.hex(3)
    @user.reset_password_sent_at = DateTime.now
    if @user.save
      @message[:done] = I18n.t("services.reset_password_token_updater.token_was_updated")
      UserMailer.reset_password(@user.email, @user.reset_password_token).deliver_now
    end
  end
end