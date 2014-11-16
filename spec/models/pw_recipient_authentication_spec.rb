require 'rails_helper'

RSpec.describe PwRecipientAuthentication, :type => :model do
  context "create" do
    it "token has entered" do
      pw_recipient_authentication = FactoryGirl.create(:pw_recipient_authentication)
      [:session_id, :password_digest].map do |attr|
        expect(pw_recipient_authentication.try(attr)).to be_present
      end
    end
  end
end
