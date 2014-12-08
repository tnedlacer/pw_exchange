class PwRecipient < ActiveRecord::Base
  belongs_to :pw_sender
  has_many :authentications, class_name: "PwRecipientAuthentication", dependent: :destroy
  
  validates :email,
    format: { with: PwExchange::EmailRegexp, allow_blank: true },
    length: { within: PwExchange::EmailLength, allow_blank: true }
end
