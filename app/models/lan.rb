class Lan < ActiveRecord::Base
  has_many :vlans, dependent: :destroy
end
