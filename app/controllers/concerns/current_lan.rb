module CurrentLan
  extend ActiveSupport::Concern

  private

    def set_lan 
      @lan = Lan.find(session[:lan_id])
    rescue ActiveRecord::RecordNotFound
      @lan = Lan.create
      session[:lan_id] = @lan.id
    end
end
