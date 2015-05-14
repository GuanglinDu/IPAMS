class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  belongs_to :department
  has_many :addresses, dependent: :destroy
  has_many :histories, through: :addresses

  searchable do
    text :name, :email, :building
    text :office_phone
    text :cell_phone
    text :room
  end
end
