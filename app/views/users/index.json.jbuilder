json.array!(@users) do |user|
  json.extract! user, :id, :name, :office_phone, :cell_phone, :email, :building, :storey, :room, :department_id
  json.url user_url(user, format: :json)
end
