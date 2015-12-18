module SearchHelper
  
  # Determines the model object 
  def who_am_i(model)
    @model_name = "unkown"
    if model.is_a?(Lan)
      @model_name = "Lan"
    elsif model.is_a?(Vlan)
      @model_name = "Vlan"
    elsif model.is_a?(Address)
      @model_name = "Address"
    elsif model.is_a?(User)
      @model_name = "User"
    elsif model.is_a?(Department)
      @model_name = "Department"
    elsif model.is_a?(History)
      @model_name = "History"
    end
  end
end
