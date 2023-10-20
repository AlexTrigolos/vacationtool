class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :vacations, dependent: :destroy

  scope :admins, -> { joins(:roles).where(roles: { name: 'admin' }) }

  def admin?
    has_role?(:admin)
  end
end
