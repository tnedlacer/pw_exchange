class PwRecipientAuthentication < ActiveRecord::Base
  include UniqueToken
  
  has_secure_password(validations: false)
  
  belongs_to :pw_recipient
  
  before_create :set_random_string
  
  def set_random_string
    self.set_unique_token(:session_id, 30)
    self.password = SecureRandom.hex(5)
  end
end
