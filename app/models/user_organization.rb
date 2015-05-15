class UserOrganization < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  scope :in, ->(organization) { where(organization_id: organization.id) }
  scope :member, ->(user) { where(user_id: user.id) }
  scope :admin, -> { where(admin: true) }
end
