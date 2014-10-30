require 'rails_helper'

describe "pw_requests/_input_field.html.erb", :type => :view do
  before do
    allow(view).to receive(:form_group_class).and_return(true)
    allow(view).to receive(:simple_format_error_message).and_return(true)
  end
  
  it "new pw_request" do
    allow(view).to receive(:pw_request) { PwRequest.new }
    render

    expect(rendered).not_to match /completeModal/
  end
  
  it "pw_request persisted" do
    pw_request = FactoryGirl.create(:pw_request)
    allow(view).to receive(:pw_request) { pw_request }
    render

    [:password, :email].map do |attr|
      expect(rendered).not_to match /#{Regexp.escape(pw_request.try(attr))}/
    end
    expect(rendered).to match /completeModal/
  end
  
  it "pw_request persisted email not registered" do
    allow(view).to receive(:pw_request) { FactoryGirl.create(:pw_request, email: nil) }
    render

    expect(rendered).not_to match /input_email/
  end
end
