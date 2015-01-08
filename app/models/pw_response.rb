class PwResponse < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  include PasswordAttribute
  
  paginates_per 10
  
  belongs_to :pw_request
  
  before_save :set_code
  after_create :send_to_requester
  
  def set_code
    self.set_unique_token(:code)
  end
  
  def encryptor
    self.pw_request.encryptor
  end
  
  def show_url
    Rails.application.routes.url_helpers.pw_responses_show_url(self.code, self.pw_request.key)
  end
  
  private
    def send_to_requester
      return if self.pw_request.email.blank?
      
      I18n.with_locale(self.pw_request.input_options[:locale].presence || I18n.locale) do
        NotificationMail.response_registered(self).deliver_now
      end
    end
  
end
