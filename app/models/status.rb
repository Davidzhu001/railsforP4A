class Status < ActiveRecord::Base
  validates :content, presence: true, length: { minimum: 2 }
  validates :user_id, presence: true

  belongs_to :user

  acts_as_votable

  self.per_page = 10

  scope :all_statuses, -> (ids) { where("user_id IN (?)", ids) }
end
