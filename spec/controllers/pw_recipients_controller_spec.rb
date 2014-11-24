require 'rails_helper'

RSpec.describe PwRecipientsController, :type => :controller do
  before do
    @pw_sender = FactoryGirl.create(:pw_sender)
  end
  after do
    expect(assigns(:pw_sender)).to eq(@pw_sender)
  end
  describe "GET 'form'" do
    it "returns http success" do
      get 'form', form_token: @pw_sender.form_token, key: @pw_sender.key
      expect(response).to be_success
    end
  end

  describe "POST 'send_mail'" do
    before do
      @key_manager = KeyManager.my_key
      @params = {
        public_key: @key_manager.public_key,
        form_token: @pw_sender.form_token,
        key: @pw_sender.key,
        encrypt: {
          email: @key_manager.public_encrypt_with_encode64(@pw_sender.pw_recipients.first.email),
        },
      }
    end
    it "returns http success" do
      expect {
        post 'send_mail', @params
        expect(response.status).to eq(200)
        ["notification_mail/pw_recipient_password", "pw_recipients/_step2"].map do |tpl|
          expect(response).to render_template(tpl)
        end
      }.to change{ PwRecipientAuthentication.count }
    end
    it "returns http success email not found" do
      expect {
        post 'send_mail', @params.deep_merge({
            encrypt: { email: @key_manager.public_encrypt_with_encode64("test") }
          })
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwRecipientAuthentication.count }
    end
    it "returns http public_key not found" do
      expect {
        post 'send_mail', @params.deep_merge({
            public_key: nil
          })
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwRecipientAuthentication.count }
    end
  end

  describe "POST 'show'" do
    before do
      @key_manager = KeyManager.my_key
      @user_key = OpenSSL::PKey::RSA.generate(2048)
      @pw_recipient_authentication = @pw_sender.pw_recipients.first.authentications.create
      @params = {
        public_key: @key_manager.public_key,
        user_public_key: @user_key.public_key,
        form_token: @pw_sender.form_token,
        key: @pw_sender.key,
        encrypt: {
          password: @key_manager.public_encrypt_with_encode64(@pw_recipient_authentication.password), 
          session_id: @key_manager.public_encrypt_with_encode64(@pw_recipient_authentication.session_id),
        },
      }
    end
    it "returns http success" do
      expect {
        post 'show', @params
        expect(response.status).to eq(200)
        ["pw_recipients/_show"].map do |tpl|
          expect(response).to render_template(tpl)
        end
      }.to change{ PwRecipientAuthentication.count }
    end
    it "returns http success authenticate failed" do
      expect {
        post 'show', @params.deep_merge({encrypt: { password: @key_manager.public_encrypt_with_encode64("password") }})
        expect(response.status).to eq(200)
        expect(response).to render_template(nil)
        expect(response.body).to match /alert alert\-danger/
      }.not_to change{ PwRecipientAuthentication.count }
    end
  end

end
