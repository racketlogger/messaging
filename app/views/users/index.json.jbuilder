json.array!(@users) do |user|
  json.extract! user, :id, :name, :image
  json.url user_url(user, format: :json)
end
