require 'spec_helper'

describe PwRequestsController, :type => :controller do

  describe "GET 'form'" do
    it "returns http success" do
      get 'form'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    before do
      @key_manager = KeyManager.my_key
      @encrypt_params = {
        password: @key_manager.public_encrypt_with_encode64("testtest"), 
        email: @key_manager.public_encrypt_with_encode64("test@example.com"),
      }
    end
    it "returns http success save" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          encrypt: @encrypt_params
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
          encrypt: @encrypt_params.merge(password: @key_manager.public_encrypt_with_encode64("test"))
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

  describe "GET 'list'" do
    before do
      @pw_request = FactoryGirl.create(:pw_request)
    end
    it "returns http success" do
      get 'list', list_token: @pw_request.list_token
      expect(response).to be_success
      ["pw_requests/list"].map do |tpl|
        expect(response).to render_template(tpl)
      end
    end
    it "returns next page" do
      20.times do
        FactoryGirl.create(:pw_response, pw_request_id: @pw_request.id)
      end
      get 'list', list_token: @pw_request.list_token, page: 2
      expect(response).to be_success
      expect(assigns[:pw_responses].current_page).to eq(2)
    end
  end
  
  describe "POST 'authentication'" do
    before do
      @key_manager = KeyManager.my_key
      @user_key = OpenSSL::PKey::RSA.generate(2048)
      @pw_request = FactoryGirl.create(:pw_request, password: "authentication_test")
      @pw_response = FactoryGirl.create(:pw_response, pw_request_id: @pw_request.id)
      @params = {
        public_key: @key_manager.public_key,
        password: @key_manager.public_encrypt_with_encode64("authentication_test"), 
        user_public_key: @user_key.public_key,
        pw_request_id: @pw_request.id,
        pw_response_ids: [@pw_response.id].join(","),
        call_back: "call_back_method"
      }
    end
    it "returns http success" do
      post 'authentication', @params
      expect(response).to be_success
      expect(response).to render_template(nil)
      expect(response.body).to match /#{Regexp.escape(I18n.t("text.authenticate_complete"))}.*user_encrypt\.decrypt/
      expect(response.body).to match /#{Regexp.escape(@params[:call_back])}/
      expect(response.body).to_not match /#{Regexp.escape(@pw_response.password)}/
    end
    it "returns authenticate failed" do
      post 'authentication', @params.merge(password: @key_manager.public_encrypt_with_encode64("authentication_failed"))
      expect(response).to be_success
      expect(response).to render_template(nil)
      expect(response.body).to match /#{Regexp.escape(I18n.t("text.authenticate_failed"))}/
    end
  end

end
