class User < ActiveRecord::Base
  belongs_to :department
  has_many :addresses, dependent: :destroy
  has_many :histories, through: :addresses
end
