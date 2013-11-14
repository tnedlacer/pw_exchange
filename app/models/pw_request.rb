class PwRequest < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  
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
  
  before_save :set_token
  
  def set_token
    self.set_unique_token(:list_token)
    self.set_unique_token(:form_token)
  end
  
end
