class UserLinkDestroyer
  attr_reader :user_link, :user_id, :error

  def initialize(user_link, user_id)
    @user_link = user_link
    @user_id = user_id
  end

  def call
    destroy
  end

  private

  def destroy
    if verification_user
      unless @user_link.destroy
        @error = I18n.t("services.user_link_destroyer.user_link_was_not_successful_destroyed")
      end
    end
  end

  def verification_user
    return true if @user_link.user_id.eql? user_id
    @error = I18n.t("services.user_link_destroyer.this_link_is_not_owned_by_the_user")
    false
  end
end