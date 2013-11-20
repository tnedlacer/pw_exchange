class PwResponse < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  
  attr_accessor :allow_all_characters
  
  belongs_to :pw_request
  
  validates :password, presence: true, length: { in: 7..140, allow_blank: true }, 
    format: { with: PwExchange::PasswordRegexp, allow_blank: true, unless: :allow_all_characters }
  
  before_save :set_code
  after_create :send_to_requester
  
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
  
  def show_url
    Rails.application.routes.url_helpers.pw_responses_show_url(self.code)
  end
  
  private
    def send_to_requester
      return if self.pw_request.email.blank?
      
      I18n.with_locale(self.pw_request.input_options[:locale].presence || I18n.locale) do
        NotificationMail.response_registered(self).deliver
      end
    end
  
end
