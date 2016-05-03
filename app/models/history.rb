class History < ActiveRecord::Base
  belongs_to :address

  searchable do
    text :usage, as: :usage_textp
    text :rec_ip, as: :rec_ip_textp
    text :mac_address, as: :mac_address_textp
    #text :assigner, as: :assigner_textp
    time :start_date
    time :end_date
  end
end
