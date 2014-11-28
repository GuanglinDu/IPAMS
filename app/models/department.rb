class Department < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :addresses, through: :users
end
