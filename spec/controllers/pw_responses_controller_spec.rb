require 'spec_helper'

describe PwResponsesController do
  before do
    @pw_request = FactoryGirl.create(:pw_request)
  end
  after do
    expect(assigns(:pw_request)).to eq(@pw_request)
  end
  describe "GET 'form'" do
    it "returns http success" do
      get 'form', form_token: @pw_request.form_token
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before do
      @key_manager = KeyManager.instance
      @encrypt_params = {
        password: @key_manager.public_encrypt_with_encode64("testtest"),
      }
    end
    it "returns http success save" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          form_token: @pw_request.form_token,
          encrypt: @encrypt_params
        expect(response.status).to eq(200)
        ["pw_responses/_input_field", "pw_responses/_complete"].map do |tpl|
          expect(response).to render_template(tpl)
        end
      }.to change{ PwResponse.count }
    end
    it "returns http success error" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          form_token: @pw_request.form_token, 
          encrypt: @encrypt_params.merge(password: @key_manager.public_encrypt_with_encode64("test"))
        expect(response.status).to eq(200)
        expect(response).to render_template("pw_responses/_input_field")
      }.not_to change{ PwResponse.count }
    end
    it "returns http public_key not found" do
      expect {
        post 'create',
          form_token: @pw_request.form_token, 
          pw_request: @pw_request_params
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwResponse.count }
    end
  end

end
