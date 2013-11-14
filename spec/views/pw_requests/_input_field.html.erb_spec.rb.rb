require 'spec_helper'

describe "pw_requests/_input_field.html.erb" do
  before do
    view.stub(:form_group_class).and_return(true)
    view.stub(:simple_format_error_message).and_return(true)
  end
  
  it "new pw_request" do
    view.stub(:pw_request) { PwRequest.new }
    render

    expect(rendered).not_to match /completeModal/
  end
  
  it "pw_request persisted" do
    view.stub(:pw_request) { FactoryGirl.create(:pw_request) }
    render

    expect(rendered).to match /completeModal/
  end
  
  it "pw_request persisted email not registered" do
    view.stub(:pw_request) { FactoryGirl.create(:pw_request, email: nil) }
    render

    expect(rendered).not_to match /input_email/
  end
end
