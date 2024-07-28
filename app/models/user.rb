class User < ApplicationRecord
  has_many :user_link
  has_many :user_token

  has_secure_password
end