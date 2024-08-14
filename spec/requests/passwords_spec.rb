require "rails_helper"

RSpec.describe "Update user's password by reset_password_token" do
  before do
    @user = create(:user, reset_password_token: SecureRandom.hex(3), reset_password_sent_at: DateTime.now)
  end

  it "successful update password" do
    patch "/users/password", params: { user: { reset_password_token: @user.reset_password_token, new_password: "Password123!",
                                               confirm_new_password: "Password123!", email: @user.email } }

    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("services.password_updater.user_password_successful_updated"))
  end

  it "try to update user's password with incorrect email" do
    patch "/users/password", params: { user: { reset_password_token: @user.reset_password_token, new_password: "Password123!",
                                               confirm_new_password: "Password123!", email: Faker::Internet.email } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.password_updater.user_not_found"))
  end

  it "try to update user's password with incorrect reset_password_token" do
    patch "/users/password", params: { user: { reset_password_token: "token", new_password: "",
                                               confirm_new_password: "", email: @user.email } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.password_updater.token_is_incorrect"))
  end

  it "try to update user's password with incorrect new password format" do
    patch "/users/password", params: { user: { reset_password_token: @user.reset_password_token, new_password: "password",
                                               confirm_new_password: "password", email: @user.email } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("validators.incorrect_format"))
  end

  it "try to update user's password with new passwords not matching" do
    patch "/users/password", params: { user: { reset_password_token: @user.reset_password_token, new_password: "Password123!",
                                               confirm_new_password: "Password123!!!", email: @user.email } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.password_updater.passwords_do_not_match"))
  end
end
