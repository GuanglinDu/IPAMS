# All models are accessible to both helpers & views
module LansHelper
  # Helper methods accessiable from the views. See
  # http://api.rubyonrails.org/classes/AbstractController/Helpers/ClassMethods.html#method-i-helper_method
  def find_lan_name(id)
    name = "unnamed"
    begin
      lan = Lan.find(id)
      name = lan.lan_name
    rescue ActiveRecord::RecordNotFound
      name = "RecordNotFound"
    end
    name
  end
end
