class WelcomeController < ApplicationController
  after_action :verify_authorized

  def index
    # Headless (no model) policies
    authorize :welcome

    respond_to do |format|
      format.html
      format.json { render json: WelcomeHelper.do_statistics }
    end
  end
end
