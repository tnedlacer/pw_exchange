class PwSender < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  include EncryptKey
  include PasswordAttribute
  
  has_many :pw_recipients
  
  before_create :set_random_string
  
  def set_random_string
    self.set_unique_token(:form_token)
  end
  
end
