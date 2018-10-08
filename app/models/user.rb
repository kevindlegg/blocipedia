class User < ApplicationRecord
  include ActiveModel::Dirty
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :wikis, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :wiki_collabs, through: :collaborators, source: :wiki

  after_initialize :init
  after_update :reset_wikis, if: :downgraded_account?

  enum role: [:standard, :premium, :admin]

  def downgrade_account
    self.update_attributes(
      role: "standard",
      stripe_customer_token: nil
    )
  end

  def downgraded_account?
    saved_change_to_attribute?(:role) && self.standard?
  end

  private

  def reset_wikis
    self.wikis.update_all(private: false)
  end

  def init
    self.role ||= :standard
  end
end
