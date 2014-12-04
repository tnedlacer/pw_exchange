require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PwExchange
  Locales = [
    [:en, "English"],
    [:ja, "日本語"],
  ]
  
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.available_locales = PwExchange::Locales.map(&:first)
    
    config.action_controller.include_all_helpers = false
  end
  
  SiteName = "PwExchange"
  AdminEmail = "admin@example.com"
  
  number_alphabet = ["0".."9", "a".."z", "A".."Z"].map(&:to_a)
  PasswordCharacters = number_alphabet + [(Array("!".."~") - number_alphabet.flatten)]
  PasswordRegexp = /\A[#{Regexp.escape(PasswordCharacters.flatten.join)}]+\z/
  PasswordLength = 7..140
  
  EmailRegexp = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  EmailLength = 5..200
end
