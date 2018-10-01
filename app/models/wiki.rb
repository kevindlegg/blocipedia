class Wiki < ApplicationRecord
  belongs_to :user
  has_many :collaborators
  has_many :users, through: :collaborators, source: :user

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true
  validates_inclusion_of :private, in: [true, false]

  before_validation :init

  def init
    self.private = false if self.private.nil?
  end
end
