class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :wikis, dependent: :destroy
  after_initialize :init

  enum role: [:standard, :premium, :admin]

  def downgrade_account
    self.update_attributes(
      role: "standard",
      stripe_customer_token: nil
    )
    self.wikis.update_all(private: false)
  end

  def init
    self.role ||= :standard
  end
end
