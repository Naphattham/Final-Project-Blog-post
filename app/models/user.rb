class User < ApplicationRecord

    # ใช้ bcrypt สำหรับจัดการรหัสผ่าน
    has_secure_password 
  
    # ความสัมพันธ์กับ Post
    has_many :posts, dependent: :destroy 
  
    # ความสัมพันธ์สำหรับระบบติดตามผู้ใช้
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
  
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :followers, through: :passive_relationships, source: :follower
  
    has_many :comments, dependent: :destroy
  
    # Active Storage สำหรับรูปโปรไฟล์
    has_one_attached :profile_picture
  
    # การตรวจสอบข้อมูล (Validations)
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, on: :create
  
    # ฟังก์ชันสำหรับการติดตาม
    def follow(other_user)
      return if self == other_user # ป้องกันการติดตามตัวเอง
      active_relationships.create(followed_id: other_user.id) unless following?(other_user)
    end
  
    def unfollow(other_user)
      relationship = active_relationships.find_by(followed_id: other_user.id)
      relationship&.destroy # ใช้ Safe Navigation เพื่อป้องกันข้อผิดพลาด
    end
  
    def following?(other_user)
      following.include?(other_user)
    end
  
    # การกำหนดค่าเริ่มต้น
    before_validation :downcase_email_and_username
  
    private
  
    # ตรวจสอบการอัปโหลดรูปภาพโปรไฟล์ (ตรวจสอบว่าเป็นไฟล์ภาพเท่านั้น)
    def validate_profile_picture_format
      if profile_picture.attached? && !profile_picture.content_type.in?(%w[image/jpeg image/png image/gif])
        errors.add(:profile_picture, "ต้องเป็นไฟล์ภาพที่รองรับเท่านั้น (JPEG, PNG, GIF)")
      end
    end
  
    # ตรวจสอบขนาดของไฟล์โปรไฟล์
    def validate_profile_picture_size
      if profile_picture.attached? && profile_picture.byte_size > 5.megabytes
        errors.add(:profile_picture, "ไฟล์ภาพต้องไม่เกิน 5MB")
      end
    end
  
    def downcase_email_and_username
      self.email = email.downcase if email.present?
  self.username = username.downcase if username.present?
    end
  end
  