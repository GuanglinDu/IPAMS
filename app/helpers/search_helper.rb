module SearchHelper
  # Sorts the search results according to their models, respectively
  def sort_results(results)
    @sorted = {lan: [], vlan: [], address: [], user: [], department: [],
               history: []}
    results.each do |result|
      if result.is_a?(Lan)
        @sorted[:lan] << result
      elsif result.is_a?(Vlan)
        @sorted[:vlan] << result
      elsif result.is_a?(Address)
        @sorted[:address] << result
      elsif result.is_a?(User)
        @sorted[:user] << result
      elsif result.is_a?(Department)
        @sorted[:department] << result
      elsif result.is_a?(History)
        @sorted[:history] << result
      end
    end
  end

  def custom_pluralize(name, count)
    if name == "lan" or name == "vlan"
      str = name.upcase
    else
      str = name.capitalize
    end
    str.pluralize(count)
  end
end
