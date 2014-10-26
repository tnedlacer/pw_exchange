require "digest/sha2"
class PwRequest < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  include EncryptKey
  
  has_secure_password(validations: false)
  
  has_many :pw_responses
  
  validates :password, presence: { on: :create }, 
    length: { within: PwExchange::PasswordLength, allow_blank: true }, 
    format: { with: PwExchange::PasswordRegexp, allow_blank: true }
  validates :email, format: { with: PwExchange::EmailRegexp, allow_blank: true },
    length: { within: PwExchange::EmailLength, allow_blank: true }
  
  serialize :input_options, Hash
  after_initialize :init

  def init
    self.input_options ||= {}
  end
  
  before_create :set_random_string
  
  def set_random_string
    self.set_unique_token(:list_token)
    self.set_unique_token(:form_token)
  end
  
  def list_url
    Rails.application.routes.url_helpers.pw_requests_list_url(self.list_token, self.key)
  end
  
end
