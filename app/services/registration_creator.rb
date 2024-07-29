require "./app/services/validators/password_validatior.rb"
require "./app/services/validators/email_validator.rb"

class RegistrationCreator
  attr_reader :user
  
  def initialize(user)
    @user = user
  end

  def call
    create
  end

  private

  def create
    if password_format_verification && email_format_verification
      @user.save
      new_user = User.find_by(email: @user.email)
      token_creator = TokenCreator.new(new_user)
      token_creator.call
    end
  end

  def password_format_verification
    password_validator = PasswordValidator.new(@user.password)
    unless password_validator.valid?
      password_validator.errors.full_messages.each do |attribute, message|
        @user.errors.add(attribute, message)
      end
      return false
    end
    true
  end

  def email_format_verification
    email_validator = EmailValidator.new(@user.email)
    unless email_validator.valid?
      email_validator.errors.full_messages.each do |attribute, message|
        @user.errors.add(attribute, message)
      end
      return false
    end
    true
  end
end
