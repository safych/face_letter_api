class UrlValidator
  include ActiveModel::Model

  attr_reader :url

  validates :url, format: { 
    with: /\A#{URI::regexp(['https'])}\z/,
    message: I18n.t("validators.incorrect_format")
  }

  def initialize(url)
    @url = url
  end
end