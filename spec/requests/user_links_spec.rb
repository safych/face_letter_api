require "rails_helper"

RSpec.describe "Get all user's links" do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end

  it "user has links, get array of links and status 200" do
    user_link1 = create(:user_link, user_id: @user.id)
    user_link2 = create(:user_link, user_id: @user.id)
    user_link3 = create(:user_link, user_id: @user.id)

    get "/user_links", headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("data", "url", user_link1.url, user_link2.url, user_link3.url)
  end

  it "user doesn't have links, get empty array and status 204" do

    get "/user_links", headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("data", "[]")
  end

  it "try to get user links with token that not exist, get error and status 401" do
    get "/user_links", headers: { "Authorization" => "token error" }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end

RSpec.describe "Create user link", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
  end

  it "create user link, get message about it and status 201" do
    post "/user_links", params: { user_link: { url: Faker::Internet.url(scheme: 'https') } },
                        headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(201)
    expect(response.body).to include(I18n.t("controllers.user_links.user_link_was_successful_created"))
  end

  it "try to create user link with incorrect format url, get error and status 422" do
    post "/user_links", params: { user_link: { url: "test error" } },
                        headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("validators.incorrect_format"))
  end

  it "try to create user link for user that has 10 links, get error and status 422" do
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)
    create(:user_link, user_id: @user.id)

    post "/user_links", params: { user_link: { url: Faker::Internet.url(scheme: 'https') } },
                        headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("services.user_link_creator.error_limit_user_links"))
  end

  it "try to create user link without token, get error and status 401" do
    post "/user_links", params: { user_link: { url: Faker::Internet.url(scheme: 'https') } }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end

RSpec.describe "Update user link", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
    @user_link = create(:user_link, user_id: @user.id)
  end

  it "update user link, get message about it and status 200" do
    put "/user_links/#{@user_link.id}", params: { user_link: { url: Faker::Internet.url(scheme: 'https') } },
                                        headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("controllers.user_links.user_link_was_successful_updated"))
  end

  it "try to update user link with incorrect url format, get error and status 422" do
    put "/user_links/#{@user_link.id}", params: { user_link: { url: "incorrect url forrmat" } },
                                        headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("validators.incorrect_format"))
  end

  it "try to update user link without token, get error and status 401" do
    put "/user_links/#{@user_link.id}", params: { user_link: { url: Faker::Internet.url(scheme: 'https') } }

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end

RSpec.describe "Destroy user link", type: :request do
  before do
    @user = create(:user)
    @user_token = create(:user_token, user_id: @user.id)
    @user_link = create(:user_link, user_id: @user.id)
  end

  it "destroy user link, get message about it and status 200" do
    delete "/user_links/#{@user_link.id}", headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(200)
    expect(response.body).to include("message", I18n.t("controllers.user_links.user_link_was_successful_destroyed"))
  end

  it "try to destroy user link that not exist, get error and status 422" do
    delete "/user_links/100", headers: { "Authorization" => @user_token.token }

    expect(response.status).to equal(404)
    expect(response.body).to include("error", I18n.t("controllers.user_links.user_link_was_not_found"))
  end

  it "try to destroy user link without token, get error and status 401" do
    delete "/user_links/#{@user_link.id}"

    expect(response.status).to equal(401)
    expect(response.body).to include("error", I18n.t("controllers.application.unauthorized"))
  end
end