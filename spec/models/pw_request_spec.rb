require 'spec_helper'

describe PwRequest, :type => :model do
  context "create" do
    it "token has entered" do
      pw_request = FactoryGirl.create(:pw_request)
      [:list_token, :form_token].map do |attr|
        expect(pw_request.try(attr)).to be_present
      end
    end
  end
  
  it "assign_encrypted_attributes" do
    key_manager = KeyManager.my_key
    pw_request = PwRequest.new
    {password: "testtesttest", email: "testtest@example.com"}.map do |attr, value|
      pw_request.assign_encrypted_attributes({
        attr => key_manager.public_encrypt_with_encode64(value)
      })
      expect(pw_request.try(attr)).to eql(value)
    end
  end
end
