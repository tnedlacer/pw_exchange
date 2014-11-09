class PwRecipient < ActiveRecord::Base
  belongs_to :pw_sender
  
  validates :email,
    format: { with: PwExchange::EmailRegexp, allow_blank: true },
    length: { within: PwExchange::EmailLength, allow_blank: true }
end
