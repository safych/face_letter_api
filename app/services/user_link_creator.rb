require "./app/services/validators/url_validator.rb"

class UserLinkCreator
  attr_reader :url, :user, :error, :token

  def initialize(url, token)
    @url = url
    @token = token
  end

  def call
    create
  end

  private

  def create
    user_id = UserToken.find_by(token: @token).user_id
    @user = User.find(user_id)
    if url_format_verification && check_user_links_count
      user_link = UserLink.new(user_id: @user.id, url: @url)
      unless user_link.save
        @error = I18n.t("services.user_link_creator.user_link_was_not_successful_created") 
      end
    end
  end

  def url_format_verification
    url_validator = UrlValidator.new(@url)
    unless url_validator.valid?
      url_validator.errors.full_messages.each do |message|
        @error = message
      end
      return false
    end
    true
  end

  def check_user_links_count
    if @user.user_link.count > 10
      @error = I18n.t("services.user_link_creator.error_limit_user_links")
      return false
    end
    true
  end
end