class Relationship < ApplicationRecord
    belongs_to :follower, class_name: "User" # ผู้ติดตาม
    belongs_to :followed, class_name: "User" # ผู้ที่ถูกติดตาม
  
    validates :follower_id, presence: true
    validates :followed_id, presence: true
  end
  