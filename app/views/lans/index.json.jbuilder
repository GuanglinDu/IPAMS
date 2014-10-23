json.array!(@lans) do |lan|
  json.extract! lan, :id, :lan_number, :lan_name, :lan_description
  json.url lan_url(lan, format: :json)
end
