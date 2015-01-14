# See https://github.com/RailsApps/rails-devise-roles/
# See https://github.com/RailsApps/rails-devise-pundit
# http://stackoverflow.com/questions/22213152/where-is-user-admin-defined-in-rails-devise-pundit-starter-app
class SystemUser < ActiveRecord::Base
  # nobody: 0, guest: 1, operator: 2, expert: 3, admin: 4 
  enum role: [:nobody, :guest, :operator, :expert, :admin] # ~> Rails 4.1

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :nobody
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
