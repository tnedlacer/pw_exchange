class PwResponse < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  
  paginates_per 10
  
  attr_accessor :allow_all_characters
  
  belongs_to :pw_request
  
  validates :password, presence: true, length: { in: 7..140, allow_blank: true }, 
    format: { with: PwExchange::PasswordRegexp, allow_blank: true, unless: :allow_all_characters }
  
  before_save :set_code
  after_create :send_to_requester
  
  def set_code
    self.set_unique_token(:code)
  end
  
  def password=(value)
    @password = value.to_s
    self.encrypted_password = self.pw_request.encryptor.encrypt_and_sign(@password)
    @password
  end
  
  def password
    @password ||= begin
        self.pw_request.encryptor.decrypt_and_verify(self.encrypted_password)
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        nil
      end
  end
  
  def show_url
    Rails.application.routes.url_helpers.pw_responses_show_url(self.code, self.pw_request.key)
  end
  
  private
    def send_to_requester
      return if self.pw_request.email.blank?
      
      I18n.with_locale(self.pw_request.input_options[:locale].presence || I18n.locale) do
        NotificationMail.response_registered(self).deliver
      end
    end
  
end
