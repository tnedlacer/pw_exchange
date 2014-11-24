require "rails_helper"

describe NotificationMail, :type => :mailer do
  describe "response_registered" do
    before do
      @pw_response = FactoryGirl.create(:pw_response)
    end
    let(:mail) { NotificationMail.response_registered(@pw_response) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password has been registered.")
      expect(mail.to).to eq([@pw_response.pw_request.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@pw_response.show_url)
    end
  end
  
  describe "pw_recipient_password" do
    before do
      @pw_recipient_authentication = FactoryGirl.create(:pw_recipient_authentication)
    end
    let(:mail) { NotificationMail.pw_recipient_password(@pw_recipient_authentication) }

    it "renders the headers" do
      expect(mail.subject).to eq("Authentication code")
      expect(mail.to).to eq([@pw_recipient_authentication.pw_recipient.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@pw_recipient_authentication.password)
    end
  end

end
