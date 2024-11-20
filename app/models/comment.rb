class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true # ตรวจสอบว่า Comment ต้องมีเนื้อหา
end
