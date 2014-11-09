require 'rails_helper'

RSpec.describe PwSendersController, :type => :controller do

  describe "GET form" do
    it "returns http success" do
      get :form
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    before do
      @key_manager = KeyManager.my_key
      @encrypt_params = {
        password: @key_manager.public_encrypt_with_encode64("testtest")
      }
      PwSender::EmailAttributes.each do |attr|
        @encrypt_params[attr] = @key_manager.public_encrypt_with_encode64("#{attr}@example.com")
      end
    end
    it "returns http success save" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          encrypt: @encrypt_params
        expect(response.status).to eq(200)
        ["pw_senders/_input_field", "pw_senders/_step2"].map do |tpl|
          expect(response).to render_template(tpl)
        end
      }.to change{ PwSender.count }
    end
    it "returns http success error" do
      expect {
        post 'create', 
          public_key: @key_manager.public_key, 
          encrypt: @encrypt_params.merge(password: @key_manager.public_encrypt_with_encode64("test"))
        expect(response.status).to eq(200)
        expect(response).to render_template("pw_senders/_input_field")
      }.not_to change{ PwSender.count }
    end
    it "returns http public_key not found" do
      expect {
        post 'create',
          encrypt: @encrypt_params
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwSender.count }
    end
  end

end
