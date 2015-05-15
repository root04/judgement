class UserProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  scope :in, ->(project) { where(project_id: project.id) }
  scope :member, ->(user) { where(user_id: user.id) }
  scope :admin, -> { where(admin: true) }
end
