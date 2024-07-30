class TokenChecker
  attr_reader :token, :status

  def initialize(token)
    @token = token
  end

  def call
    verification
  end

  private

  def verification
    found_token = UserToken.find_by(token: @token)
    @status = found_token ? true : false
  end
end