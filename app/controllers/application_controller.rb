class ApplicationController < ActionController::Base
  include Pundit

  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Select locale according to user's selection
  before_action :set_i18n_locale_from_params, :authenticate_system_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Used to reset the password
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end

  protected

    # [deprecated] I18n.enforce_available_locales will default to true in the future.
    # If you really want to skip validation of your locale you can set
    # I18n.enforce_available_locales = false to avoid this message.
    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    def default_url_options
      { locale: I18n.locale }
    end
end

