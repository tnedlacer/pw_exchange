require "digest/sha2"
class PwRequest < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  
  attr_accessor :key
  
  has_secure_password(validations: false)
  
  has_many :pw_responses
  
  validates :password, presence: { on: :create }, 
    length: { within: 7..140, allow_blank: true }, 
    format: { with: PwExchange::PasswordRegexp, allow_blank: true }
  validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true },
    length: { within: 5..200, allow_blank: true }
  
  serialize :input_options, Hash
  after_initialize :init

  def init
    self.input_options ||= {}
  end
  
  before_create :set_random_string
  
  def set_random_string
    self.set_unique_token(:list_token)
    self.set_unique_token(:form_token)
    self.key = SecureRandom.hex(10)
    self.key_digest = BCrypt::Password.create(self.key)
  end
  
  def authenticate_key(unencrypted_key)
    BCrypt::Password.new(self.key_digest) == unencrypted_key && self.key = unencrypted_key
  end
  
  def list_url
    Rails.application.routes.url_helpers.pw_requests_list_url(self.list_token, self.key)
  end
  
  def encryptor
    @encryptor ||= ActiveSupport::MessageEncryptor.new(Digest::SHA256.hexdigest(self.key))
  end
  
end
