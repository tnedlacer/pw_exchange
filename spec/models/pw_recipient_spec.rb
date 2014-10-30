require 'rails_helper'

RSpec.describe PwRecipient, :type => :model do
  context "create" do
    it "success" do
      FactoryGirl.create(:pw_recipient)
    end
  end
end
