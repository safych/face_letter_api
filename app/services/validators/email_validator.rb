class EmailValidator
  include ActiveModel::Model

  attr_reader :email

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/, message: :invalid }
  validate :email_must_be_unique

  def initialize(email)
    @email = email
  end

  private

  def email_must_be_unique
    if User.exists?(email: email)
      errors.add(:email, :taken, message: I18n.t("validators.has_already_been_taken"))
    end
  end
end