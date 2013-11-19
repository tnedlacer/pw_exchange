class PwResponsesController < ApplicationController
  
  before_action :find_form_token
  
  private
    def find_form_token
      @pw_request = PwRequest.where(:form_token => params[:form_token]).first
      if @pw_request.blank?
        render_404
      end
    end
  public
  
  def form
    @pw_response = @pw_request.pw_responses.build
  end
  
  def create
    if [params[:public_key], KeyManager.instance.public_key].map{|str| str.to_s.gsub(/\s/, "") }.uniq.size != 1 || params[:encrypt].blank?
      alert_html = ApplicationController.helpers.escape_javascript("<div class=\"alert alert-danger\">#{I18n.t("text.send_error")}</div>")
      render js: "$(\"#step1 .input_section\").before(\"#{alert_html}\");"
      return
    end
    
    pw_response = @pw_request.pw_responses.build
    pw_response.assign_encrypted_attributes(params.require(:encrypt).permit(:password))
    pw_response.remote_ip = request.remote_ip
    pw_response.user_agent = request.user_agent
    
    if pw_response.save
      html = {}
      ["input_field", "complete"].map do |template|
        html[template.to_sym] = ApplicationController.helpers.escape_javascript(render_to_string(partial: template, locals: {pw_response: pw_response}))
      end
      render js: "$(\"#encrypt_submit\").hide(); $(\"div.input_section\").html(\"#{html[:input_field]}\"); $(\"div#content\").append(\"#{html[:complete]}\");"
    else
      input_field_html = ApplicationController.helpers.escape_javascript(render_to_string(partial: "input_field", locals: {pw_response: pw_response}))
      render js: "$(\"div.input_section\").html(\"#{input_field_html}\");$.rails.enableElement($(\"#encrypt_submit\"));"
    end
  end
end
