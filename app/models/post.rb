class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy # เพิ่มความสัมพันธ์กับ Comment
  has_many :likes, dependent: :destroy # ความสัมพันธ์กับ Like (ถ้ามี)
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
end
