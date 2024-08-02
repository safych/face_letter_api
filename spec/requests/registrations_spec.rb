require "rails_helper"

RSpec.describe "Operations with registration", type: :request do
  it "create user, get message about successful sign up, get token and status 201" do
    post "/users", params: { user: { email: Faker::Internet.email, 
                                     password: "Test1234!",
                                     name: "Bob",
                                     surname: "Wood" } }

    expect(response.status).to equal(201)
    expect(response.body).to include(I18n.t("controllers.registrations.successful_sign_up"))
    response_body = JSON.parse(response.body)
    token = response_body["data"]
    expect(token).to match(/\A[a-f0-9]{60}\z/)
  end

  it "create user with incorrect password format, get error and status 422" do
    post "/users", params: { user: { email: Faker::Internet.email,
                                     password: "dgef324",
                                     name: "Bob",
                                     surname: "Wood" } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", "Password is too short (minimum is 8 characters)", "Password incorrect format")
  end

  it "create user with incorrect email format, get error and status 422" do
    post "/users", params: { user: { email: "erg@ve", 
                                     password: "Test1234!",
                                     name: "Bob",
                                     surname: "Wood" } }
    
    expect(response.status).to equal(422)
    expect(response.body).to include("error", "Email is invalid")
  end


  it "create user with email that uses other user, get error and status 422" do
    create(:user, email: "exa@ef.m")

    post "/users", params: { user: { email: "exa@ef.m", 
                                     password: "Test1234!",
                                     name: "Bob",
                                     surname: "Wood" } }

    expect(response.status).to equal(422)
    expect(response.body).to include("error", I18n.t("validators.has_already_been_taken"))
  end
end