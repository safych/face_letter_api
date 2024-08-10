require "rails_helper"

RSpec.describe "Update user's update_email_token", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end
  
  it "successful token update" do
    patch "/users/update_email_token", params: { user: { current_password: "Test1234!" } },
                                       headers: { "Authorization" => @user_token.token }

    @user.reload
    expect(response.status).to equal(200)
    expect(response.body).to include(I18n.t("services.update_email_token_creator.token_was_updated"))
    expect(@user.update_email_token).not_to eq(nil)
    expect(@user.update_email_sent_at).not_to eq(nil)
  end

  it "try to update token with incorrect current_password" do
    patch "/users/update_email_token", params: { user: { current_password: "Test12!!!" } },
                                       headers: { "Authorization" => @user_token.token }

    @user.reload
    expect(response.status).to equal(422)
    expect(response.body).to include(I18n.t("services.update_email_token_creator.not_correct_password"))
    expect(@user.update_email_token).to eq(nil)
    expect(@user.update_email_sent_at).to eq(nil)
  end

  it "try to update token without session token" do
    patch "/users/update_email_token", params: { user: { current_password: "Test1234!" } }

    expect(response.status).to equal(401)
    expect(response.body).to include(I18n.t("controllers.application.unauthorized"))
  end
end