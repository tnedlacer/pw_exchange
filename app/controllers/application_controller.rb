class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_locale
  
  private
    def set_locale
      locale = cookies[:locale].presence || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym
      if I18n.available_locales.include?(locale)
        cookies[:locale] = locale
      end
    rescue
    ensure
      I18n.locale = cookies[:locale] || I18n.default_locale
    end
    
    def render_404
      raise ActionController::RoutingError.new('Not Found')
    end
end
