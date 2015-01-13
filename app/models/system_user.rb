# See https://github.com/RailsApps/rails-devise-roles/
class SystemUser < ActiveRecord::Base
  ROLES = { nobody: 0, guest: 1, operator: 2, expert: 3, admin: 4 }
  #enum role: [:nobody, :guest, :operator, :expert, :admin] # ~> Rails 4.1
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    @role = 0
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
