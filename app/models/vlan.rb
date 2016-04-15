class Vlan < ActiveRecord::Base
  belongs_to :lan

  has_many :addresses, dependent: :destroy
  has_many :reserved_addresses, dependent: :destroy
  has_many :users, through: :addresses

  validates :vlan_number, :vlan_name, :subnet_mask, :vlan_description,
            presence: true
  # Valid VLAN number is only between 1..4096 (Range)
  validates :vlan_number, inclusion: {in: 1..4096}
  validates :gateway, :static_ip_start, :static_ip_end,
            presence: true, uniqueness: true
end
