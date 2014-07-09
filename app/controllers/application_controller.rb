class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_locale
  
  private
    def set_locale
      locale = params[:locale].presence ||
        cookies[:locale].presence ||
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      
      if I18n.available_locales.include?(locale.to_sym)
        cookies[:locale] = locale
      end
      if params[:locale].present?
        redirect_to params.except(:locale)
      end
    rescue
    ensure
      I18n.locale = cookies[:locale] || I18n.default_locale
    end
    
    def render_404
      raise ActionController::RoutingError.new('Not Found')
    end
    
    def alert_danger_html_with_escape_javascript(content)
      ApplicationController.helpers.escape_javascript("<div class=\"alert alert-danger\">#{content}</div>")
    end
end
