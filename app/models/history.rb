class History < ActiveRecord::Base
  belongs_to :address

  searchable do
    text :usage, as: :usage_textp
    #text :rec_ip, as: :rec_ip_textp
    text :user_name, as: :user_name_textp
    text :mac_address, as: :mac_address_textp
    #text :assigner, as: :assigner_textp
    time :start_date
    time :end_date
    join(:ip, :target => Address, :type => :text, :join => { :from => :id, :to => :address_id })
  end
end
