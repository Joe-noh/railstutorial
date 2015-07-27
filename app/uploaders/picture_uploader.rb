# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Riak
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 400]

  def key
    original_filename
  end

  def bucket
    "picture"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
