class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  default_scope -> { order("created_at DESC") }
  mount_uploader :picture, PictureUploader

  private

  	# Validates the size of an uploaded picture.
  	def picture_size
  		if picture.size > 1.megabytes
  			errors.add(:picture, "should be less than 1MB")
  		end
  	end
end