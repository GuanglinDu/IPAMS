class SearchController < ApplicationController
  # See https://github.com/sunspot/sunspot
  # Sunspot search.
  # See https://github.com/outoftime/sunspot/wiki/Working-with-search
  # http://goo.gl/LOaOrn 
  # Note: Each model must include a searchable block,
  # or a NilClass error will occur.
  def index
    if params[:search].present? 
      @search = Sunspot.search(Address, User, Department) do 
        fulltext params[:search]
        paginate page: params[:page] || 1, per_page: 50
      end 
    else
      @search = Sunspot.search(Address, User, Department) do |query| 
        query.paginate page: params[:page] || 1, per_page: 50
      end 
    end

    # Type Sunspot::Search::PaginatedCVollection < Array
    @results = @search.results

    # Creates app/policy/paginated_collection_policy.rb to fix the following error
    # Pundit::NotDefinedError in SearchController#index
    # unable to find policy Sunspot::Search::PaginatedCollectionPolicy
    authorize @results
    @sorted_results = sort_per_model(@results)
  end
 
  private

  def sort_per_model(results)
    sorted_results = {
      lan: [],
      vlan: [],
      address: [],
      user: [],
      department: [],
      history: []
    }

    results.each do |model|
      if model.is_a?(Lan)
        sorted_results[:lan] << model  
      elsif model.is_a?(Vlan)
        sorted_results[:vlan] << model  
      elsif model.is_a?(Address)
        sorted_results[:address] << model  
      elsif model.is_a?(User)
        sorted_results[:user] << model  
      elsif model.is_a?(Department)
        sorted_results[:department] << model  
      elsif model.is_a?(History)
        sorted_results[:history] << model  
      end
    end
    sorted_results.delete_if{ |key, value| value.empty? } 
    return sorted_results
  end
end
