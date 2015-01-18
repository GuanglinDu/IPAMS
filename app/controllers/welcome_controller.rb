class WelcomeController < ApplicationController
  after_action :verify_authorized

  def index
    # Headless (no model) policies
    authorize :welcome
  end
end
