class Collaborator < ApplicationRecord
  belongs_to :user
  belongs_to :wiki

  validates :user_id, uniqueness: { scope: :wiki_id }
end