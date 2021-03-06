class KeyManager
  attr_accessor :rsa
  
  def initialize(key)
    @rsa = OpenSSL::PKey::RSA.new(key)
  end
  
  def self.my_key
    self.new File.read(Rails.root.join("rsa/rsa_priv.pem"))
  end
  
  def self.my_public_key_eq?(key)
    [key, self.my_key.public_key].map{|str| str.to_s.gsub(/\s/, "") }.uniq.size == 1
  end
  
  def public_key
    rsa.public_key.to_s
  end
  
  [
    [[:private_encrypt, :public_encrypt], :encode64],
    [[:private_decrypt, :public_decrypt], :decode64], 
  ].map do |rsa_methods, base64_method|
    rsa_methods.map do |rsa_method|
      define_method(rsa_method){|str| rsa.try(rsa_method, str).force_encoding(Encoding::UTF_8) }
      case base64_method
      when :encode64
        define_method("#{rsa_method}_with_#{base64_method}"){|str|
          Base64.try(base64_method, self.try(rsa_method, str))
        }
      when :decode64
        define_method("#{rsa_method}_with_#{base64_method}"){|str|
          self.try(rsa_method, Base64.try(base64_method, str))
        }
      end
    end
  end
  
  module ActiveRecord
    def assign_encrypted_attributes(encrypted_attributes)
      key_manager = KeyManager.my_key
      decrypt_attributes = Hash[
        encrypted_attributes.map do |attribute, encrypted_value|
          [attribute, key_manager.private_decrypt_with_decode64(encrypted_value.to_s)]
        end
      ]
      self.assign_attributes(decrypt_attributes)
    end
  end
  
end
