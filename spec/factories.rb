FactoryBot.define do
  
  factory :user do
    name { "Joe" }
    surname { "Clooney" }
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create("Test1234!") }
  end

  factory :user_token do
    association :user
    token { SecureRandom.hex(30) }
  end

  factory :user_link do
    association :user
    url { Faker::Internet.url(scheme: 'https') }
  end
end