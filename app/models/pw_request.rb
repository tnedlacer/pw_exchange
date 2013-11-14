class PwRequest < ActiveRecord::Base
  include UniqueToken
  
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
  
  def assign_encrypted_attributes(encrypted_attributes)
    key_manager = KeyManager.instance
    decrypt_attributes = Hash[
      encrypted_attributes.map do |attribute, encrypted_value|
        [attribute, key_manager.private_decrypt_with_decode64(encrypted_value.to_s)]
      end
    ]
    self.assign_attributes(decrypt_attributes)
  end
  
end
