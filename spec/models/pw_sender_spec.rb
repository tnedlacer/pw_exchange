require 'rails_helper'

RSpec.describe PwSender, :type => :model do
  context "create" do
    it "token has entered" do
      pw_sender = FactoryGirl.create(:pw_sender)
      [:form_token, :key].map do |attr|
        expect(pw_sender.try(attr)).to be_present
      end
    end
    context "validates_presence_of_pw_recipients" do
      it "valid" do
        pw_sender = FactoryGirl.build(:pw_sender, email_0: "email@example.com")
        expect(pw_sender.valid?).to equal(true)
      end
      it "invalid" do
        pw_sender = FactoryGirl.build(:pw_sender, email_0: nil)
        expect(pw_sender.valid?).to equal(false)
      end
    end
    it "destroy_blank_pw_recipients" do
      pw_sender = FactoryGirl.build(:pw_sender)
      PwSender::EmailAttributes.each do |attr|
        pw_sender.try("#{attr}=", "##{attr}@example.com")
      end
      pw_sender.save
      expect(pw_sender.pw_recipients.size).to equal(PwSender::EmailAttributes.size)
      pw_sender.try("#{PwSender::EmailAttributes.first}=", nil)
      pw_sender.save
      expect(pw_sender.pw_recipients.size).to equal(PwSender::EmailAttributes.size - 1)
    end
  end
end
