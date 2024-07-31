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
    if check_user_links_count
      user_link = UserLink.new(user_id: @user.id, url: @url)
      unless user_link.save
        @error = I18n.t("services.user_link_creator.user_link_was_not_successful_created") 
      end
    end
  end

  def check_user_links_count
    if @user.user_link.count > 10
      @error = I18n.t("services.user_link_creator.error_limit_user_links")
      return false
    end
    true
  end
end