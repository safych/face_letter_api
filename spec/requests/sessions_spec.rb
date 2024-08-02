require "rails_helper"

RSpec.describe "Create session", type: :request do
  before do
    @user = create(:user)
  end

  it "create user token, get message about it and get status 201" do
    post "/users/sign_in", params: { user: { email: @user.email, password: "Test1234!" } }

    expect(response.status).to equal(201)
    expect(response.body).to include(I18n.t("controllers.sessions.successful_sign_in"))
    response_body = JSON.parse(response.body)
    token = response_body["data"]
    expect(token).to match(/\A[a-f0-9]{60}\z/)
  end

  it "try to sign in with wrong user's email, get error and status 401" do
    post "/users/sign_in", params: { user: { email: "user@email.co", password: "Test1234!" } }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("services.session_creator.user_not_found"))
  end

  it "try to sign in with wrong user's password, get error and status 401" do
    post "/users/sign_in", params: { user: { email: @user.email, password: "Test123" } }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("services.session_creator.invalid_password"))
  end
end

RSpec.describe "Destroy session", type: :request do
  before do
    @user_token = create(:user_token)
  end

  it "destroy user token, get message about it and status 200" do
    delete "/users/sign_out", headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include(I18n.t("controllers.sessions.successful_exit_from_the_account"))
  end

  it "destroy user token that not exist, get error and status 422" do
    delete "/users/sign_out", headers: { "Authorization" => "wrong_token" }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("controllers.sessions.unsuccessful_exit_from_the_account"))
  end
end