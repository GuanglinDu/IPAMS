class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  belongs_to :department
  has_many :addresses, dependent: :destroy
  has_many :histories, through: :addresses

  searchable do
    text :name, as: :name_textp
    text :email, as: :eamil_textp
    text :building, as: :building_textp
    text :office_phone, as: :office_phone_textp
    text :cell_phone, as: :cell_phone_textp
    text :room, as: :room_textp
  end
end
