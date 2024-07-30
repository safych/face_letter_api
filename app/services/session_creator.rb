class SessionCreator
  attr_reader :params, :token, :error, :user

  def initialize(params)
    @params = params
  end

  def call
    create
  end

  private

  def create
    @token = SecureRandom.hex(30) if verification_user
  end

  def verification_user
    @user = User.find_by(email: @params[:email])

    if @user.nil?
      @error = I18n.t("services.session_creator.user_not_found")
    elsif !@user.authenticate(@params[:password])
      @error = I18n.t("services.session_creator.invalid_password")
    end
    
    return false if @error
    true
  end
end