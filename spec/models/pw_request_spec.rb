require 'spec_helper'

describe PwRequest do
  context "create" do
    it "token has entered" do
      pw_request = FactoryGirl.create(:pw_request)
      [:list_token, :form_token].map do |attr|
        expect(pw_request.try(attr)).to be_present
      end
    end
  end
end
