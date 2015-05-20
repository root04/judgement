class OrganizationMembersController < ApplicationController
  before_action :assign_configurable_organization
  before_action :assign_new_member, only: [:create]
  before_action :assign_target_user, only: [:destroy, :update, :revoke]

  def create
    unless @new_member.member_of?(@organization)
      @new_member.join(@organization)
      flash[:message] = message_for(:success, name: @new_member.name)
    end
    redirect_to dashboard_organization_path(@organization)
  end

  def destroy
    @organization.dismiss_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to dashboard_organization_path(@organization)
  end

  def update
    @organization.grant_admin_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to dashboard_organization_path(@organization)
  end

  def revoke
    @organization.revoke_admin_member(@target_user)
    flash[:message] = message_for(:success, name: @target_user.name)
    redirect_to dashboard_organization_path(@organization)
  end

  private

  def assign_configurable_organization
    @organization = current_user.organizations.find(params[:organization_id])
    unless current_user.configurable?(@organization)
      raise Oniwa::Forbidden
    end
  end

  def assign_new_member
    @new_member = User.with(params[:email]).last
    unless @new_member
      flash[:error] = message_for(:user_not_found)
      flash[:email] = params[:email]
      redirect_to dashboard_organization_path(@organization)
    end
  end

  def assign_target_user
    @target_user = @organization.users.find(params[:id])
    if current_user == @target_user
      raise Oniwa::BadRequest
    end
  end
end
