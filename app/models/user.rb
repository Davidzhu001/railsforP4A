class User < ActiveRecord::Base
  include Gravtastic
  gravtastic  :secure => true, :size => 70

  acts_as_voter

  validates :name, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :statuses, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { state: 'accepted' }).order('name DESC') }, :through => :friendships

  has_many :pending_friendships, -> { where(state: 'pending') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :requested_friendships, -> { where(state: 'requested') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :requested_friends, through: :requested_friendships, source: :friend

  has_many :blocked_friendships, -> { where(state: 'blocked') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :blocked_friends, through: :blocked_friendships, source: :friend

  has_many :accepted_friendships, -> { where(state: 'accepted') }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :accepted_friends, through: :accepted_friendships, source: :friend

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged


  def combined_statuses
    (friends.map(&:statuses) + statuses).flatten.
      sort_by {|status| status.created_at}.reverse!
  end

  def slug_candidates
    [
      :name,
      [:name, (65 + rand(26)).chr],
      [:name, (65 + rand(26)).chr, rand(99)]
    ]
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end
end
