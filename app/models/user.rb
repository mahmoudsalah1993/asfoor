class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_requests, class_name:  "Request",
                                  foreign_key: "requester_id",
                                  dependent:   :destroy
  has_many :passive_requests, class_name:  "Request",
                                   foreign_key: "requested_id",
                                   dependent:   :destroy

  has_many :requesting, through: :active_requests,source: :requested
  has_many :requesters, through: :passive_requests, source: :requester
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :last_name, presence: true
  validates :birthdate, presence: true

  mount_uploader :profile_picture, PictureUploader
  validate :picture_size
  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    feeds = Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    public_feed = Micropost.where(is_private: false)
    t = Micropost.where(:id => (feeds + public_feed))
  end
  def publicfeed
    feed = microposts.where(is_private: false)
  end

  # Follows a user
  def follow(other_user)
    passive_requests.find_by(requester_id: other_user.id).destroy
    active_relationships.create(followed_id: other_user.id)
    passive_relationships.create(follower_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
    passive_relationships.find_by(follower_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  def friend_request(other_user)
    puts "****************Friend request**************"
    active_requests.create(requested_id: other_user.id)
  end

  def cancel_friend_request(other_user)
    puts "****************Cancel friend request**************"
    active_requests.find_by(requested_id: other_user.id).destroy
  end

  def requesting?(other_user)
    requesting.include?(other_user)
  end

private

    # Validates the size of an uploaded picture
    def picture_size
      if profile_picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
