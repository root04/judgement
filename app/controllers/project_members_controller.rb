class ProjectMembersController < ApplicationController
  before_action :assign_configurable_project
  before_action :assign_organization, only: [:create, :destroy, :update, :revoke]
  before_action :assign_new_member, only: [:create]
  before_action :assign_target_user, only: [:destroy, :update, :revoke]

  def create
    unless @new_member.member_of?(@project)
      @new_member.join(@project)
      flash[:message] = message_for(:success, name: @new_member.name)
    end

    redirect_to organization_project_path(@organization, @project)
  end

  def destroy
    @project.dismiss_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to organization_project_path(@organization, @project)
  end

  def update
    @project.grant_admin_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to organization_project_path(@organization, @project)
  end

  def revoke
    @project.revoke_admin_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to organization_project_path(@organization, @project)
  end

  private

  def assign_organization
    @organization = @project.organization
    unless @organization.id == params[:organization_id].to_i
      raise Oniwa::Forbidden
    end
  end

  def assign_configurable_project
    @project = current_user.projects.find(params[:project_id])
    unless current_user.configurable?(@project)
      raise Oniwa::Forbidden
    end
  end

  def assign_new_member
    @new_member = User.with(params[:email]).take
    unless @new_member.try(:member_of?, @organization)
      flash[:error] = message_for(:user_not_found)
      flash[:email] = params[:email]
      redirect_to organization_project_path(@organization, @project)
    end
  end

  def assign_target_user
    @target_user = @project.users.find(params[:id])
    if current_user == @target_user
      raise Oniwa::BadRequest
    end
  end
end
