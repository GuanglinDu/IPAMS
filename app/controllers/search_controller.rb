class SearchController < ApplicationController
  # Sunspot search. See https://github.com/outoftime/sunspot/wiki/Working-with-search
  # http://stackoverflow.com/questions/29880837/rails-4-and-sunspot-searching-across-several-related-models
  def index
    if params[:search].present? 
      #@search = Sunspot.search(Lan, Vlan, Address, User, Department) do |m| 
      @search = Sunspot.search(Address) do |m| 
        m.fulltext params[:search]
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @results = @search.results
      
      # Creates app/policy/paginated_collection_policy.rb to fix the following error
      # Pundit::NotDefinedError in SearchController#index
      # unable to find policy Sunspot::Search::PaginatedCollectionPolicy
      authorize @results
    end
  end

  protected
    
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
      elsif model.is_a?(Vlan)
        @model_name = "Department"
      end
    end
end
