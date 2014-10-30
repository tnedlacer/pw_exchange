require 'rails_helper'

describe "pw_responses/_input_field.html.erb", :type => :view do
  before do
    allow(view).to receive(:form_group_class).and_return(true)
    allow(view).to receive(:simple_format_error_message).and_return(true)
  end
  
  it "new pw_response" do
    allow(view).to receive(:pw_response) { FactoryGirl.build(:pw_response) }
    render

    expect(rendered).not_to match /text\-warning/
  end
  
  it "pw_response persisted" do
    allow(view).to receive(:pw_response) { FactoryGirl.create(:pw_response) }
    render

    expect(rendered).to match /text\-warning/
  end
end