class User < ActiveRecord::Base
  include DateTimeHelper

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
           foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
           foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :stars, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token

  # HTML5-compatible email-format validator
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/

  before_save { self.email.downcase! }
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false unless digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
    update_attributes(activated: true,
                      activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes(reset_digest: User.digest(reset_token),
                      reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    quoted_true = ActiveRecord::Base.connection.quoted_true
    following_ids = 'SELECT followed_id FROM relationships WHERE  follower_id = :user_id'
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id OR starred = #{quoted_true}", user_id: id).includes(:user)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns true if the current user is followed by the other user.
  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def avatar_url
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  def star?(at = Time.zone.now)
    star = stars.find_by(date: shifted_date(at))
    !!(star && star.accepted?)
  end

  # Returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a ramdon token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.current_stars(date)
    User.joins(:stars).where(activated: true, stars: {date: date, status: :accepted})
  end
end
