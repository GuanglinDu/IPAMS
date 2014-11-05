class Vlan < ActiveRecord::Base
  belongs_to :lan
  has_many :reserved_addresses
end
