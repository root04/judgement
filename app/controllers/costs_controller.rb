class CostsController < ApplicationController
  before_action :detect_organization
  before_action :detect_project

  def create
    @cost = @project.actual.costs.new(cost_params)

    unless @cost.save
      flash[:errors] = @cost.errors.full_messages
    end
    redirect_to organization_project_path(@organization, @project)
  end

  private

  def cost_params
    params.require(:cost).permit(:name, :description, :order_date, :category, :cost, :payee)
  end

  def detect_project
    @project = Project.find(params[:project_id])
  end

  def detect_organization
    @organization = Organization.find(params[:organization_id])
  end
end
