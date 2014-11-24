require 'rails_helper'

RSpec.describe "pw_recipients/_step1.html.erb", :type => :view do
  before do
    allow(view).to receive(:form_group_class).and_return(true)
  end
  
  it "success" do
    @pw_recipient = FactoryGirl.create(:pw_recipient)
    render
  end
end
