class PwRecipientsController < ApplicationController
  
  before_action :find_form_token
  
  private
    def find_form_token
      @pw_sender = PwSender.where(:form_token => params[:form_token]).first
      if @pw_sender.blank? || !@pw_sender.authenticate_key(params[:key])
        render_404
      end
    end
    
    def validate_params(alert_insert_selector)
      if !KeyManager.my_public_key_eq?(params[:public_key]) || params[:encrypt].blank?
        render js: %Q! $("#{alert_insert_selector}").before("#{alert_danger_html_with_escape_javascript(I18n.t("text.send_error"))}");!
        false
      else
        true
      end
    end
    
  public
  
  def form
    @pw_recipient = @pw_sender.pw_recipients.build
    @pw_recipient.pw_sender = @pw_sender
  end
  
  def send_mail
    return unless validate_params("#step1 .input_section")
    
    key_manager = KeyManager.my_key
    pw_recipient = @pw_sender.pw_recipients.where(email: key_manager.private_decrypt_with_decode64(params.require(:encrypt)[:email])).first
    if pw_recipient.present?
      pw_recipient_authentication = pw_recipient.authentications.create
      pw_recipient_authentication.send_password
      render js: 
        %Q! $("div#content").append("#{ApplicationController.helpers.escape_javascript(render_to_string(partial: "step2"))}");! +
        %Q! $("#encrypt_session_id").val(#{key_manager.public_encrypt_with_encode64(pw_recipient_authentication.session_id).to_json});! +
        %Q! $("#encrypt_submit").slideUp();! +
        %Q! $("#input_email").attr("readonly", true);! +
        %Q! $("div#step2").slideDown();! +
        %Q! setTimeout(function(){ create_user_encrypt(); }, 1000);!
    else
      render js: 
        "$(\"#step1 .input_section\").before(\"#{alert_danger_html_with_escape_javascript(I18n.t("text.recipient_email_not_found"))}\"); $.rails.enableFormElement($(\"#encrypt_submit\"));"
    end
  end
  
  def show
    return unless validate_params("#step2 .input_section")
    
    key_manager = KeyManager.my_key
    pw_recipient_authentication = PwRecipientAuthentication.where(session_id: key_manager.private_decrypt_with_decode64(params.require(:encrypt)[:session_id])).first
    if @pw_sender.id == pw_recipient_authentication.pw_recipient.pw_sender_id && pw_recipient_authentication.authenticate(key_manager.private_decrypt_with_decode64(params.require(:encrypt)[:password]).downcase)
      pw_recipient_authentication.destroy
      user_key_manager = KeyManager.new(params[:user_public_key])
      render js: 
        %Q! $("div#content").append("#{ApplicationController.helpers.escape_javascript(render_to_string(partial: "show"))}");! +
        %Q! $("#collapse_password div").text(user_encrypt.decrypt(#{user_key_manager.public_encrypt_with_encode64(@pw_sender.password).to_json}));! +
        %Q! $("#step2 #encrypt_submit").slideUp();! +
        %Q! $("#input_password").attr("readonly", true);! +
        %Q! $("div#step3").slideDown();!
    else
      render js: 
        "$(\"#step2 .input_section\").before(\"#{alert_danger_html_with_escape_javascript(I18n.t("text.authenticate_failed"))}\"); $.rails.enableFormElement($(\"#step2 #encrypt_submit\"));"
    end
  end
  
end
