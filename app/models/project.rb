class Project < ActiveRecord::Base
  belongs_to :organization

  has_many :user_projects
  has_many :users, through: :user_projects

  has_many :budget
  has_one :actual

  validates :name, presence: true
  validates :organization_id, presence: true

  accepts_nested_attributes_for :user_projects
  accepts_nested_attributes_for :actual

  def dismiss_member(user)
    user_projects.member(user).each(&:destroy)
  end

  def grant_admin_member(user)
    user_projects.member(user).take.update_attributes!(admin: true)
  end

  def revoke_admin_member(user)
    user_projects.member(user).take.update_attributes!(admin: false)
  end
end
