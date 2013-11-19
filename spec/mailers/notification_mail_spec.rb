require "spec_helper"

describe NotificationMail do
  describe "response_registered" do
    before do
      @pw_response = FactoryGirl.create(:pw_response)
    end
    let(:mail) { NotificationMail.response_registered(@pw_response) }

    it "renders the headers" do
      mail.subject.should eq("Password has been registered.")
      mail.to.should eq([@pw_response.pw_request.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@pw_response.show_url)
    end
  end

end
