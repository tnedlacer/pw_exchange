module UniqueToken
  extend ActiveSupport::Concern
  
  def set_unique_token(attribute, length = 20)
    while
      token = SecureRandom.hex(length)
      next if self.class.where(attribute => token).present?
      
      return write_attribute(attribute, token)
    end
  end
end
