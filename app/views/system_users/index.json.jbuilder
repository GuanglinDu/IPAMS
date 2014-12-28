json.array!(@system_users) do |system_user|
  json.extract! system_user, :id, :name, :passowrd
  json.url system_user_url(system_user, format: :json)
end
