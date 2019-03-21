module CurrentVlan
  extend ActiveSupport::Concern

  private

  def set_vlan 
    @vlan = Vlan.find(session[:vlan_id])
  rescue ActiveRecord::RecordNotFound
    @vlan = Vlan.create
    session[:vlan_id] = @vlan.id
  end
end
