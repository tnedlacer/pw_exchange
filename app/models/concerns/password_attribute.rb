module PasswordAttribute
  extend ActiveSupport::Concern
  included do
    attr_accessor :allow_all_characters
    validates :password, presence: true, length: { in: PwExchange::PasswordLength, allow_blank: true }, 
      format: { with: PwExchange::PasswordRegexp, allow_blank: true, unless: :allow_all_characters }
  end
  
  def password=(value)
    @password = value.to_s
    self.encrypted_password = self.encryptor.encrypt_and_sign(@password)
    @password
  end
  
  def password
    @password ||= begin
        self.encryptor.decrypt_and_verify(self.encrypted_password)
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        nil
      end
  end
end
