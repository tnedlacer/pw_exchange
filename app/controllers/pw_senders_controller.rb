class PwSendersController < ApplicationController
  def form
  end
  
  def create
    if !KeyManager.my_public_key_eq?(params[:public_key]) || params[:encrypt].blank?
      render js: "$(\"#step1 .input_section\").before(\"#{alert_danger_html_with_escape_javascript(I18n.t("text.send_error"))}\");"
      return
    end
    
    pw_sender = PwSender.new
    pw_sender.assign_encrypted_attributes(params.require(:encrypt).permit(:password, *PwSender::EmailAttributes))
    if pw_sender.save
      html = {}
      pw_sender.pw_recipients.build while pw_sender.pw_recipients.size < PwSender::MaxPwRecipient
      ["input_field", "step2"].map do |template|
        html[template.to_sym] = ApplicationController.helpers.escape_javascript(render_to_string(partial: template, locals: {pw_sender: pw_sender}))
      end
      render js: "$(\"#encrypt_submit\").hide(); store_values(); $(\"div.input_section\").html(\"#{html[:input_field]}\"); restore_values(); $(\"div#content\").append(\"#{html[:step2]}\").append(\"#{html[:step3]}\");;"
    else
      input_field_html = ApplicationController.helpers.escape_javascript(render_to_string(partial: "input_field", locals: {pw_sender: pw_sender}))
      render js: "store_values(); $(\"div.input_section\").html(\"#{input_field_html}\"); restore_values(); $.rails.enableFormElement($(\"#encrypt_submit\"));"
    end
  end
end
