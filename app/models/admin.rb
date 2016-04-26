# https://github.com/plataformatec/devise
# https://github.com/RailsApps/rails-devise-roles/
# https://github.com/RailsApps/rails-devise-pundit
# http://goo.gl/Ex30Is 
class Admin < ActiveRecord::Base
  # Must be >= Rails 4.1
  enum role: [:nobody, :guest, :operator, :expert, :admin, :root]

  after_initialize :set_default_role, :if => :new_record?

  # Includes default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def set_default_role
    self.role ||= :nobody
  end
end
