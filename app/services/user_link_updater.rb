require "./app/services/validators/url_validator.rb"

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
    if url_format_verification && verification_user
      unless @user_link.update(url: @new_url)
        @error = I18n.t("services.user_link_updater.user_link_was_not_successful_updated")
      end
    end
  end

  def url_format_verification
    url_validator = UrlValidator.new(@new_url)
    unless url_validator.valid?
      url_validator.errors.full_messages.each do |message|
        @error = message
      end
      return false
    end
    true
  end

  def verification_user
    return true if @user_link.user_id.eql? user_id
    @error = I18n.t("services.user_link_updater.this_link_is_not_owned_by_the_user")
    false
  end
end