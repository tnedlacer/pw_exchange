class PwResponse < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  
  belongs_to :pw_request
  
  validates :password, presence: true, length: { in: 7..140, allow_blank: true },
    format: { with: PwExchange::PasswordRegexp, allow_blank: true }
  
  before_save :set_code
  
  def set_code
    self.set_unique_token(:code)
  end
  
  # DBのエンコードの制限に引っかからないように文字をエスケープする
  EscapedPasswordSeparator = ","
  
  def password=(value)
    @password = value.to_s
    self.escaped_password = @password.unpack("U*").join(EscapedPasswordSeparator)
    @password
  end
  
  def password
    @password ||= self.escaped_password.to_s.split(EscapedPasswordSeparator).pack("U*")
  end
end
