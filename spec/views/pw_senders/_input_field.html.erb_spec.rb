require 'rails_helper'

describe "pw_senders/_input_field.html.erb", :type => :view do
  before do
    allow(view).to receive(:form_group_class).and_return(true)
    allow(view).to receive(:simple_format_error_message).and_return(true)
  end
  
  it "new pw_sender" do
    allow(view).to receive(:pw_sender) { PwSender.new }
    render

    expect(rendered).not_to match /completeModal/
  end
  
  it "pw_sender persisted" do
    pw_sender = FactoryGirl.create(:pw_sender)
    allow(view).to receive(:pw_sender) { pw_sender }
    render

    [:password, :email_0].map do |attr|
      expect(rendered).not_to match /#{Regexp.escape(pw_sender.try(attr))}/
    end
    expect(rendered).to match /completeModal/
  end
end
