class History < ActiveRecord::Base
  belongs_to :address

  # Nested searching in SunSpot Solr https://bit.ly/2IqWDl3
  #after_save :reindex_parent

  searchable do
    text :usage,       as: :usage_textp
    text :ip_address,  as: :ip_address_textp # nested searching
    text :user_name,   as: :user_name_textp
    text :mac_address, as: :mac_address_textp
    #text :assigner,   as: :assigner_textp
    time :start_date
    time :end_date
    join(:ip, target: Address, type: :text,
         join: {from: :id, to: :address_id})
  end

  private

  def ip_address
    Address.find(address_id).ip
  end
end
