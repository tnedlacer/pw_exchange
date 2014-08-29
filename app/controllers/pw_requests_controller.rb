class PwRequestsController < ApplicationController
  def form
  end
  
  def create
    if !KeyManager.my_public_key_eq?(params[:public_key]) || params[:encrypt].blank?
      render js: "$(\"#step1 .input_section\").before(\"#{alert_danger_html_with_escape_javascript(I18n.t("text.send_error"))}\");"
      return
    end
    
    pw_request = PwRequest.new
    pw_request.assign_encrypted_attributes(params.require(:encrypt).permit(:password, :email))
    pw_request.input_options = {locale: I18n.locale}
    if pw_request.save
      html = {}
      ["input_field", "step2", "step3"].map do |template|
        html[template.to_sym] = ApplicationController.helpers.escape_javascript(render_to_string(partial: template, locals: {pw_request: pw_request}))
      end
      render js: "$(\"#encrypt_submit\").hide(); $(\"div.input_section\").html(\"#{html[:input_field]}\"); $(\"div#content\").append(\"#{html[:step2]}\").append(\"#{html[:step3]}\");;"
    else
      input_field_html = ApplicationController.helpers.escape_javascript(render_to_string(partial: "input_field", locals: {pw_request: pw_request}))
      render js: "$(\"div.input_section\").html(\"#{input_field_html}\");$.rails.enableElement($(\"#encrypt_submit\"));"
    end
  end
  
  def list
    @pw_request = PwRequest.where(:list_token => params[:list_token]).first
    if @pw_request.blank?
      render_404
      return
    end
    @pw_responses = @pw_request.pw_responses.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def authentication
    if !KeyManager.my_public_key_eq?(params[:public_key]) || [:password, :user_public_key, :pw_request_id].any?{|key| params[key].blank? }
      render js: %Q!$("#authentication .form-horizontal").before("#{alert_danger_html_with_escape_javascript("#{I18n.t("text.authenticate_failed")} #{I18n.t("text.authenticate_reload_browser")}")}");!
      return
    end
    
    pw_request = PwRequest.where(:id => params[:pw_request_id]).first
    key_manager = KeyManager.my_key
    if pw_request.present? && pw_request.authenticate(key_manager.private_decrypt_with_decode64(params[:password])) && pw_request.authenticate_key(params[:key])
      pw_responses = pw_request.pw_responses.where(:id => params[:pw_response_ids].to_s.split(","))
      user_key_manager = KeyManager.new(params[:user_public_key])
      js_objects = pw_responses.map do |res|
        "$.parseJSON(user_encrypt.decrypt(#{user_key_manager.public_encrypt_with_encode64(Hash[res.id, res.password].to_json).to_json}))"
      end
      render js: 
        %Q! var bar = set_progress(#{I18n.t("text.authenticate_complete").to_json}, 100);! + 
        %Q! bar.removeClass().addClass("progress-bar progress-bar-success");! +
        %Q! $("#authentication .form-horizontal").slideUp("slow");! +
        %Q! #{params[:call_back]}($.extend(#{js_objects.join(',')}));!
    else
      render js: 
        %Q! var bar = set_progress(#{I18n.t("text.authenticate_failed").to_json}, 90);! + 
        %Q! bar.removeClass().addClass("progress-bar progress-bar-danger");!
    end
  end
  
end
