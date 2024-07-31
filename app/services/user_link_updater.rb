class UserLinkUpdater
  attr_reader :user_link, :user_id, :new_url, :error

  def initialize(user_link, user_id, new_url)
    @user_link = user_link
    @user_id = user_id
    @new_url = new_url
  end

  def call
    update
  end

  private

  def update
    if verification_user
      unless @user_link.update(url: new_url)
        @error = I18n.t("services.user_link_updater.user_link_was_not_successful_updated")
      end
    end
  end

  def verification_user
    return true if @user_link.user_id.eql? user_id
    @error = I18n.t("services.user_link_updater.this_link_is_not_owned_by_the_user")
    false
  end
end