json.extract!(micropost, :id, :content, :created_at, :picture_url)
json.starred(micropost.starred?)

json.user do
  json.partial! micropost.user
end
