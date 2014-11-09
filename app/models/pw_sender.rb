class PwSender < ActiveRecord::Base
  include UniqueToken
  include KeyManager::ActiveRecord
  include EncryptKey
  include PasswordAttribute
  
  MaxPwRecipient = 5
  EmailAttributes = Array(0...MaxPwRecipient).map{|i| "email_#{i}".to_sym }
  attr_accessor *EmailAttributes
  
  has_many :pw_recipients
  accepts_nested_attributes_for :pw_recipients
  
  before_validation :build_pw_recipients
  validate :validates_presence_of_pw_recipients
  before_create :set_random_string
  before_save :destroy_blank_pw_recipients
  
  def set_random_string
    self.set_unique_token(:form_token)
  end
  
  def build_pw_recipients
    EmailAttributes.each_with_index do |attr, i|
      pw_recipients = self.pw_recipients[i] || self.pw_recipients.build
      pw_recipients.email = self.try(attr)
    end
  end
  
  def validates_presence_of_pw_recipients
    if self.pw_recipients.none?{|pw_recipient| pw_recipient.email.present? }
      self.pw_recipients.first.errors.add(:email, :blank)
      self.errors.add(:pw_recipients, :blank)
    end
  end
  
  def destroy_blank_pw_recipients
    self.pw_recipients.destroy(self.pw_recipients.select{|pw_recipient| pw_recipient.email.blank? })
  end
  
end
