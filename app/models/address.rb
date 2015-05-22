class Address < ActiveRecord::Base
  validates :ip, presence: true, uniqueness: true
  validates :mac_address, uniqueness: true, allow_blank: true

  belongs_to :vlan
  belongs_to :user
  has_many :histories, dependent: :destroy

  # Searches with Sunspot
  # Matching substrings in fulltext search, see
  # https://github.com/sunspot/sunspot/wiki/Matching-substrings-in-fulltext-search
  searchable do
    text :usage, :as => :usage_textp
    text :ip, :as => :ip_textp
    #text :ip
    text :mac_address, :as => :mac_address_textp
    text :assigner, :as => :assigner_textp
    time :start_date
    time :end_date
  end
end
