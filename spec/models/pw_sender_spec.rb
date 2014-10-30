require 'rails_helper'

RSpec.describe PwSender, :type => :model do
  context "create" do
    it "token has entered" do
      pw_sender = FactoryGirl.create(:pw_sender)
      [:form_token, :key].map do |attr|
        expect(pw_sender.try(attr)).to be_present
      end
    end
  end
end
