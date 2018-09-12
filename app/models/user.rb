class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :wikis, dependent: :destroy
  before_save { self.role ||= :standard }

  enum role: [:standard, :premium, :admin]
end
