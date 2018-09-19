class Amount < ApplicationRecord
  scope :default, -> { find_by(default: true) }
end
