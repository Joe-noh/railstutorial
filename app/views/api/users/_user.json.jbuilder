json.extract!(user, :id, :name, :avatar_url)
json.star(user.star?)
