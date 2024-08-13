require "rails_helper"

RSpec.describe "Update user's email" do
  before do
    @user = create(:user, update_email_token: SecureRandom.hex(3), update_email_sent_at: DateTime.now)
    @user_token = create(:user_token, user_id: @user.id)
  end
  
  it "successful update email" do
    patch "/users/email", params: { user: { update_email_token: @user.update_email_token, new_email: Faker::Internet.email } },
                           headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("services.email_updater.user_email_successful_updated"))
  end

  it "try to update email with incorrect update_email_token" do
    patch "/users/email", params: { user: { update_email_token: "fake", new_email: Faker::Internet.email } },
                           headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.email_updater.token_for_update_email_is_incorrect"))
  end

  it "try to update email with incorrect token session" do
    patch "/users/email", params: { user: { update_email_token: @user.update_email_token, new_email: Faker::Internet.email } },
                           headers: { "Authorization" => "fake" }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end
