json.extract!(@user, :id, :name, :avatar_url)

json.star(@user.star?)
json.followers_count(@user.followers.count)
json.following_count(@user.following.count)
json.micropost_count(@user.microposts.count)

json.microposts do
  json.array!(@microposts) do |micropost|
    json.partial! micropost
  end
end
