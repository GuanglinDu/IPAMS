class Address < ActiveRecord::Base
  default_scope { order(:address_order) }

  belongs_to :vlan, touch: true
  belongs_to :user, touch: true

  has_many :histories, dependent: :destroy

  validates :ip, presence: true, uniqueness: true
  #validates :mac_address,
  #          uniqueness: true,
  #          allow_blank: true,
  #          length: {is: 14},
  #          format: {
  #            with: /[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}/,
  #            message: "only allows XXXX-XXXX-XXXX"
  #          }

  #before_validation :upcase_mac
  #after_validation :upcase_mac

  searchable do
    text :usage,       as: :usage_textp
    text :ip,          as: :ip_textp
    text :mac_address, as: :mac_address_textp
    text :assigner,    as: :assigner_textp
    time :start_date
    time :end_date
  end

  protected

  def upcase_mac
    self.mac_address = self.mac_address.upcase
  end
end
