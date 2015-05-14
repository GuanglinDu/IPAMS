class SearchController < ApplicationController
  # Sunspot search. See https://github.com/outoftime/sunspot/wiki/Working-with-search
  def index
    keywords = params[:search]
    keywords = keywords.strip if keywords

    # No keywords, no search
    @results = nil
    if keywords && keywords != "" 
      #search = Sunspot.search(Address)
      search = Address.search do
       fulltext keywords
      end 
      # Type Sunspot::Search::PaginatedCollection < Array
      @results = search.results
      
      # Creates app/policy/paginated_collection_policy.rb to fix the following error
      # Pundit::NotDefinedError in SearchController#index
      # unable to find policy Sunspot::Search::PaginatedCollectionPolicy
      authorize @results
    end
  end
end
