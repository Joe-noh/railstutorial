require 'net/http'

class PicturesController < ApplicationController
  def show
    url = "http://ryoshin-storage:8098/bucket/picture/keys/#{params[:key]}"
    res = Net::HTTP.request_get(url)

    if res.code == '200'
      res.read_body
    else
      nil
    end
  end
end
