class Lan < ActiveRecord::Base
  has_many :vlans, dependent: :destroy

  validates :lan_number, presence: true
  validates :lan_name, :lan_description, presence: true, length: {minimum: 5}
  validates :lan_number, :lan_name, uniqueness: true

  searchable do
    text :lan_name,        as: :lan_name_textp
    text :lan_description, as: :lan_description_textp
    integer :lan_number
  end
end
