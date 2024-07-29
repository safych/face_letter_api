class User < ApplicationRecord
  has_many :user_link, dependent: :destroy
  has_many :user_token, dependent: :destroy

  has_secure_password
end