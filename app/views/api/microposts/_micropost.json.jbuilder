json.extract!(micropost, :id, :content, :created_at, :picture_url)

json.user do
  json.partial! micropost.user
end
