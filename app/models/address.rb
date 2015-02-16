class Address < ActiveRecord::Base
  validates :ip, presence: true, uniqueness: true
  validates :mac_address, uniqueness: true, allow_blank: true

  belongs_to :vlan
  belongs_to :user
  has_many :histories, dependent: :destroy
end
