# To solve error unable to find policy Sunspot::Search::PaginatedCollectionPolicy
# when authorizing with Pundit.
class Sunspot::Search::PaginatedCollectionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
