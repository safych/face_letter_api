class UserMailer < ApplicationMailer
  def update_email(email, token)
    @email = email
    @token = token
    mail(to: @email, subject: I18n.t("mailers.user_mailer.token_that_will_confirm_change_email"))
  end

  def reset_password(email, token)
    @email = email
    @token = token
    mail(to: @email, subject: I18n.t("mailers.user_mailer.token_that_will_confirm_change_password"))
  end
end