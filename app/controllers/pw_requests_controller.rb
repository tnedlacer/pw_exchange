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
end
