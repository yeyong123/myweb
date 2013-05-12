#encoding:utf-8
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy #保证所有依赖用户的微博都删除。
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy 
  #删除用户所有依赖的关系都删除
  has_many :followed_users, through: :relationships, source: :followed 
  #source参数设置所有被关注用户的来源！
  #建立反转后的关系表，用followed_id做外键
  has_many :reverse_relationships, foreign_key: "followed_id", 
           class_name: "Relationship",
           dependent: :destroy
  #设置关注者用户的关系关联。through “通过”
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save {|user| user.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: { case_sensitive: false } 
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  def feed
    Micropost.from_users_followed_by(self)
  end


  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end


private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
