# http://blog.carbonfive.com/2013/10/21/migrating-to-pundit-from-cancan/
# http://through-voidness.blogspot.com/2013/10/advanced-rails-4-authorization-with.html
class ApplicationController < ActionController::Base
  include IPAMSConstants
  include ApplicationHelper 
  include Pundit # authorization mechanism

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_cache_buster
  # http://stackoverflow.com/questions/26241357/overriding-devise-sessionscontroller-destroy
  #skip_before_action :verify_signed_out_user
  #to tackle: Filter chain halted as :verify_signed_out_user
  #skip_before_filter :verify_signed_out_user, only: :destroy
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Selects locale according to user's selection & athenticates users
  before_action :set_i18n_locale_from_params, :authenticate_system_user!

  # Notice: Global authorizing causes unauthorization problem in Devise!!!
  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Resets the password
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password, :role) 
    }
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
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

    # Customizes Pundit user other than current_user: https://github.com/elabs/pundit
    def pundit_user
      SystemUser.find_by(email: current_system_user.email)
    end

    # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in-out
    #def after_sign_in_path_for(resource)
      # return the path based on resource
    #end

  private

   def user_not_authorized
     flash[:error] = "You are not authorized to perform this action."
     #self.response_body = nil # This should resolve the redirect root.
     redirect_to request.headers["Referer"] || welcome_path
   end 
end
