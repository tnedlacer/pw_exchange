require 'rails_helper'

describe PwResponse, :type => :model do
  context "create" do
    before do
      @pw_response = FactoryGirl.create(:pw_response)
    end
    it "code has entered" do
      expect(@pw_response.code).to be_present
    end
    it "encrypted_password has entered" do
      expect(@pw_response.encrypted_password).to be_present
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
        pw_response = FactoryGirl.create(:pw_response, password: value, allow_all_characters: true)
        pw_request = pw_response.pw_request
        pw_response = PwResponse.where(id: pw_response.id).first
        pw_response.pw_request.key = pw_request.key
        expect(pw_response.password).to eq(value)
      end
    end
  end
  context "disallow all characters" do
    it "valid" do
      pw_response = FactoryGirl.build(:pw_response, password: "aaaaaaa")
      expect(pw_response.valid?).to equal(true)
    end
    it "invalid" do
      pw_response = FactoryGirl.build(:pw_response, password: "aaaaaaaあいう")
      expect(pw_response.valid?).to equal(false)
    end
  end
end
