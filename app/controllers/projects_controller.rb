class ProjectsController < ApplicationController
  before_action :require_belonging_organization

  def new
    @project = Project.new
  end

  def show
    @project = @organization.projects.find(params[:id])

    unless current_user.member_of?(@project)
      raise Cravitee::Forbidden
    end
  end

  def create
    @project = current_user.create_project(
      params.require(:project).permit(:name).merge(organization: @organization)
    )

    if @project.persisted?
      redirect_to organization_project_path(@organization, @project)
    else
      @errors = @project.errors
      render :new
    end
  end

  private

  def require_belonging_organization
    @organization = current_user.organizations.find(params[:organization_id])
  end
end
