class PwResponsesController < ApplicationController
  
  before_action :find_form_token, except: [:show]
  
  private
    def find_form_token
      @pw_request = PwRequest.where(:form_token => params[:form_token]).first
      if @pw_request.blank? || !@pw_request.authenticate_key(params[:key])
        render_404
      end
    end
  public
  
  def form
    @pw_response = @pw_request.pw_responses.build
  end
  
  def create
    if !KeyManager.my_public_key_eq?(params[:public_key]) || params[:encrypt].blank?
      render js: "$(\"#step1 .input_section\").before(\"#{alert_danger_html_with_escape_javascript(I18n.t("text.send_error"))}\");"
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
      render js: "$(\"#encrypt_submit\").hide(); store_values(); $(\"div.input_section\").html(\"#{html[:input_field]}\"); restore_values(); $(\"div#content\").append(\"#{html[:complete]}\");"
    else
      input_field_html = ApplicationController.helpers.escape_javascript(render_to_string(partial: "input_field", locals: {pw_response: pw_response}))
      render js: "store_values(); $(\"div.input_section\").html(\"#{input_field_html}\"); restore_values(); $.rails.enableFormElement($(\"#encrypt_submit\"));"
    end
  end
  
  def show
    @pw_responses = PwResponse.where(:code => params[:code]).preload(:pw_request)
    @pw_request = @pw_responses.first.pw_request if @pw_responses.present?
    if @pw_responses.blank? || !@pw_request.authenticate_key(params[:key])
      render_404
      return
    end
    render "pw_requests/list"
  end
  
end
