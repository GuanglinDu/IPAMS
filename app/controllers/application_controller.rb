# http://blog.carbonfive.com/2013/10/21/migrating-to-pundit-from-cancan/
# http://through-voidness.blogspot.com/2013/10/advanced-rails-4-authorization-with.html
class ApplicationController < ActionController::Base
  include Pundit # authorization mechanism

  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Select locale according to user's selection
  before_action :set_i18n_locale_from_params, :authenticate_system_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Verify that controller actions are authorized. Optional, but good.
  # Enforces access right checks for individuals resources
  after_filter :verify_authorized, except: :index
  # Enforces access right checks for collections
  after_filter :verify_policy_scoped, only: :index

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Used to reset the password
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end

  # Customize Pundit user: https://github.com/elabs/pundit
  def pundit_user
    SystemUser.find_by(email: current_system_user.email)
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

  private

   def user_not_authorized
     flash[:error] = "You are not authorized to perform this action."
     #self.response_body = nil # This should resolve the redirect root.
     #redirect_to request.headers["Referer"] || help_index_path
   end 
end

