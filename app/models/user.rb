class User < ActiveRecord::Base
  belongs_to :department, touch: true

  has_many :addresses, dependent: :destroy
  has_many :histories, through: :addresses

  validates :name, presence: true, uniqueness: true

  searchable do
    text :name,         as: :name_textp
    text :email,        as: :eamil_textp
    text :building,     as: :building_textp
    text :office_phone, as: :office_phone_textp
    text :cell_phone,   as: :cell_phone_textp
    text :room,         as: :room_textp
    text :title,        as: :title_textp
  end
end
