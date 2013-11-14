require 'spec_helper'

describe PwRequestsController do

  describe "GET 'form'" do
    it "returns http success" do
      get 'form'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before do
      @key_manager = KeyManager.instance
      @pw_request_params = {
        password: @key_manager.public_encrypt_with_encode64("testtest"), 
        email: @key_manager.public_encrypt_with_encode64("test@example.com"),
      }
    end
    it "returns http success save" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          pw_request: @pw_request_params
        expect(response.status).to eq(200)
        ["pw_requests/_input_field", "pw_requests/_step2", "pw_requests/_step3"].map do |tpl|
          expect(response).to render_template(tpl)
        end
      }.to change{ PwRequest.count }
    end
    it "returns http success error" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          pw_request: @pw_request_params.merge(password: @key_manager.public_encrypt_with_encode64("test"))
        expect(response.status).to eq(200)
        expect(response).to render_template("pw_requests/_input_field")
      }.not_to change{ PwRequest.count }
    end
    it "returns http public_key not found" do
      expect {
        post 'create',
          pw_request: @pw_request_params
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwRequest.count }
    end
  end

end
