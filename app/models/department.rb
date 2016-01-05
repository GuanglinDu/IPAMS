class Department < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :addresses, through: :users

  validates :dept_name, presence: true, uniqueness: true

  searchable do
    text :dept_name
    text :location
  end
end
