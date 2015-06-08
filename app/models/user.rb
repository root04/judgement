class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { maximum: 255, minimum: 3 }

  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  has_many :user_projects
  has_many :projects, through: :user_projects

  scope :with, ->(email) { where(email: email) }

  def configurable?(group)
    relation_for(group).admin.exists?
  end

  def create_organization(name)
    Organization.create(
      name: name,
      user_organizations_attributes: [
        { user: self, admin: true }
      ]
    )
  end

  def create_project(arg)
    Project.create(
      name: arg[:name],
      organization_id: arg[:organization].id,
      user_projects_attributes: [
        { user: self, admin: true }
      ],
      actual_attributes: {
        costs_attributes: {}
      }
    )
  end

  def member_of?(group)
    relation_for(group).exists?
  end

  def join(group)
    case group.class.table_name.to_sym
    when :organizations
      UserOrganization.create!(user: self, organization: group, admin: false)
    when :projects
      UserProject.create!(user: self, project: group, admin: false)
    else
      raise ArgumentError, 'unknown group'
    end
  end

  private

  def relation_for(group)
    case group.class.table_name.to_sym
    when :organizations
      user_organizations.in(group)
    when :projects
      user_projects.in(group)
    else
      raise ArgumentError, 'unknown group'
    end
  end
end
