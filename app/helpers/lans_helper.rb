# All models are accessible to both helpers & views
module LansHelper
  # Eric Torrey - Disambiguate Rails helpers:
  # https://thoughtbot.com/blog/disambiguate-rails-helpers
  def self.find_lan_name(id)
    name = "unnamed"
    begin
      name  = Lan.find(id).lan_name
    rescue ActiveRecord::RecordNotFound
      name = "RecordNotFound"
    end
    name
  end

  # Creates a cache key for the Lan#index view with pagination.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +offset+:: the offset of the pagination 
  def cache_key_for_lans(caller_name, offset)
    max_updated_at = Lan.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "lans/#{caller_name}-#{offset}-#{max_updated_at}"
  end

  # Creates a cache key for a single LAN.
  # params:
  # +caller_name+:: the name of the calling template or partial
  # +lan+:: the LAN object, a record 
  def cache_key_for_lan(caller_name, lan)
    updated_at = lan.updated_at.try(:utc).try(:to_s, :number)
    "lans/#{caller_name}-#{lan.id}-#{updated_at}"
  end
end
