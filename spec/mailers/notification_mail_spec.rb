require "spec_helper"

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

end
