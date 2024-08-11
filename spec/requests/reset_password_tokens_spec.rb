require "rails_helper"

RSpec.describe "Update user's reset_password_token", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end
  
  it "successful token update" do
    patch "/users/reset_password_token", params: { user: { email: @user.email } }

    @user.reload
    expect(response.status).to equal(200)
    expect(response.body).to include(I18n.t("services.reset_password_token_updater.token_was_updated"))
    expect(@user.reset_password_token).not_to eq(nil)
    expect(@user.reset_password_sent_at).not_to eq(nil)
  end

  it "try to update token with incorrect email" do
    patch "/users/reset_password_token", params: { user: { email: Faker::Internet.email } }

    @user.reload
    expect(response.status).to equal(422)
    expect(response.body).to include(I18n.t("services.reset_password_token_updater.user_not_found"))
    expect(@user.reset_password_token).to eq(nil)
    expect(@user.reset_password_sent_at).to eq(nil)
  end
end