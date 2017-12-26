class SearchController < ApplicationController
  # https://github.com/sunspot/sunspot
  # https://github.com/outoftime/sunspot/wiki/Working-with-search
  # http://goo.gl/85PYFF
  # Each model must inclue a searchable block, or a NilClass error will ocurr.
  def index
    if params[:search].present? 
      search = Sunspot.search(Lan, Vlan, Address, User, Department,
                              History) do |query|
        query.fulltext params[:search]
        query.paginate page: params[:page] || 1, per_page: 50
      end 

      # Type Sunspot::Search::PaginatedCVollection < Array
      @results = search.results

      # Creates app/policy/paginated_collection_policy.rb to fix error:
      #   Pundit::NotDefinedError in SearchController#index
      #   unable to find policy Sunspot::Search::PaginatedCollectionPolicy
      authorize @results
    end
  end
end
