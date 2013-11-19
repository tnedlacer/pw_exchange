require 'spec_helper'

describe PwResponse do
  context "create" do
    before do
      @pw_response = FactoryGirl.create(:pw_response)
    end
    it "code has entered" do
      expect(@pw_response.code).to be_present
    end
    it "escaped_password has entered" do
      expect(@pw_response.escaped_password).to be_present
    end
  end
  context "send_to_requester" do
    it "send" do
      expect {
        FactoryGirl.create(:pw_response)
      }.to change{ ActionMailer::Base.deliveries.size }
    end
    it "not send" do
      expect {
        pw_response = FactoryGirl.build(:pw_response)
        pw_response.pw_request.email = nil
        pw_response.save
      }.not_to change{ ActionMailer::Base.deliveries.size }
    end
  end
  context "escaped_password unescape" do
    {
      number: "123456789",
      alphabet_and_symbols: "aBcd!\"#%$\\&'()=~|{}_*?+`P",
      multibyte: "あいうえお𠀋𡈽𡌛𡑮𡢽𠮟𡚴𡸴𣇄",
      other: "(☝ ՞ਊ ՞)☝ （´◉◞౪◟◉)",
    }.map do |label, value|
      it label do
        pw_response = FactoryGirl.create(:pw_response, password: value)
        pw_response.reload
        expect(pw_response.password).to equal(value)
      end
    end
  end
end
