class Address < ActiveRecord::Base
  belongs_to :vlan
  belongs_to :department
  belongs_to :user
  has_many :histories, dependent: :destroy
end
