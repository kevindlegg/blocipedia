class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :wikis, dependent: :destroy
  after_initialize :init

  enum role: [:standard, :premium, :admin]

  private
  def init
    self.role ||= :standard
  end
end
