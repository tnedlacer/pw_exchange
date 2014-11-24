require 'rails_helper'

RSpec.describe "pw_recipients/_step2.html.erb", :type => :view do
  before do
    allow(view).to receive(:form_group_class).and_return(true)
  end
  
  it "success" do
    @pw_sender = FactoryGirl.create(:pw_sender)
    render
  end
end
