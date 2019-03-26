class Vlan < ActiveRecord::Base
  default_scope { order(:vlan_name) }
  default_scope { order(:vlan_number) }

  belongs_to :lan

  has_many :addresses, dependent: :destroy
  has_many :reserved_addresses, dependent: :destroy
  has_many :users, through: :addresses

  validates :vlan_number, :vlan_name, :subnet_mask, :vlan_description,
            presence: true
  # Valid VLAN number is only between 1..4094 (Range)
  validates :vlan_number, inclusion: {in: 1..4094}
  validates :gateway, :static_ip_start, :static_ip_end,
            presence: true, uniqueness: true

  searchable do
    text :vlan_name,        as: :vlan_name_textp 
    text :vlan_description, as: :vlan_description_textp
    integer :vlan_number
  end
end
