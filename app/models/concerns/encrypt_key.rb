module EncryptKey
  extend ActiveSupport::Concern
  included do
    attr_accessor :key
    before_create :set_encrypt_key
  end
  
  def set_encrypt_key
    self.key ||= SecureRandom.hex(5)
    self.key_digest ||= BCrypt::Password.create(self.key)
  end
  
  
  def authenticate_key(unencrypted_key)
    BCrypt::Password.new(self.key_digest) == unencrypted_key && self.key = unencrypted_key
  end
  
  
  def encryptor
    self.set_encrypt_key if self.key.blank?
    @encryptor ||= ActiveSupport::MessageEncryptor.new(Digest::SHA256.hexdigest(self.key))
  end
  
end
