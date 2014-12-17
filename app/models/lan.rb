class Lan < ActiveRecord::Base
  validates :lan_number, presence: true
  validates :lan_name, :lan_description, presence: true, length: { minimum: 5 }
  validates :lan_number, :lan_name, uniqueness: true

  has_many :vlans, dependent: :destroy
end
