class TokenCreator
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    create
  end

  private

  def create
    token = SecureRandom.hex(30)
    while UserToken.exists?(token: token)
      token = SecureRandom.hex(30)
    end
    UserToken.new(user_id: @user.id, token: token).save
  end
end