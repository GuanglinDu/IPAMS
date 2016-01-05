class Lan < ActiveRecord::Base
  has_many :vlans, dependent: :destroy

  validates :lan_number, presence: true
  validates :lan_name, :lan_description, presence: true, length: {minimum: 5}
  validates :lan_number, :lan_name, uniqueness: true

  searchable do
    string :lan_name
    integer :lan_number
  end
end
