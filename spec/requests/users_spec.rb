require "rails_helper"

RSpec.describe "Update name and surname", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end

  it "successful update name and surname" do
    patch "/users/update", params: { user: { name: "Name", surname: "Surname" } },
                           headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("services.user_updater.user_data_successful_updated"))
  end

  it "try to update name and surname without token" do
    patch "/users/update", params: { user: { name: "Name", surname: "Surname" } }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end

RSpec.describe "Update password", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end

  it "successful update password" do
    patch "/users/update", params: { user: { current_password: "Test1234!", new_password: "Pass123!!!" } },
                           headers: { "Authorization" => @user_token.token }
    
    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("services.user_updater.user_password_successful_updated"))
  end

  it "try to update password with incorrect current_password" do
    patch "/users/update", params: { user: { current_password: "Test12", new_password: "Pass123!!!" } },
                           headers: { "Authorization" => @user_token.token }
    
    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.user_updater.not_correct_password"))
  end

  it "try to update password with incorrect new_password format" do
    patch "/users/update", params: { user: { current_password: "Test1234!", new_password: "fassddrd" } },
                           headers: { "Authorization" => @user_token.token }
    
    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("validators.incorrect_format"))
  end

  it "try to update password without token" do
    patch "/users/update", params: { user: { current_password: "Test1234!", new_password: "Pass123!!!" } }
    
    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end