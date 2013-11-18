require 'spec_helper'

describe "pw_responses/_input_field.html.erb" do
  before do
    view.stub(:form_group_class).and_return(true)
    view.stub(:simple_format_error_message).and_return(true)
  end
  
  it "new pw_response" do
    view.stub(:pw_response) { PwResponse.new }
    render

    expect(rendered).not_to match /text\-warning/
  end
  
  it "pw_response persisted" do
    view.stub(:pw_response) { FactoryGirl.create(:pw_response) }
    render

    expect(rendered).to match /text\-warning/
  end
end