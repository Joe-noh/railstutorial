class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  def full_picture_url(prefix)
    prefix.concat picture.url if picture.url
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'should be less than 5MB')
    end
  end
end
