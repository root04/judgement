class Organization < ActiveRecord::Base
  has_many :user_organizations
  has_many :users, through: :user_organizations
  has_many :projects

  validates :name, presence: true, length: { maximum: 255, minimum: 3 }

  scope :no, ->(id) { where(id: id) }
  scope :of, ->(name) { where(name: name) }

  accepts_nested_attributes_for :user_organizations

  paginates_per 5

  def configurable_by?(user)
    user_organizations.admin.member(user).exists?
  end

  def dismiss_member(user)
    user_organizations.member(user).each(&:destroy)
  end

  def grant_admin_member(user)
    user_organizations.member(user).take.update_attributes!(admin: true)
  end

  def admin_members
    user_organizations.admin.map(&:user)
  end

  def revoke_admin_member(user)
    user_organizations.member(user).take.update_attributes!(admin: false)
  end
end
