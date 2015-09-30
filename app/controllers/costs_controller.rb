class CostsController < ApplicationController
  before_action :detect_organization
  before_action :detect_project
  before_action :detect_profit_loss
  before_action :detect_cost

  def index
  end

  def show
  end

  def create
    @cost = @project.actual.costs.new(cost_params)

    unless @cost.save
      flash[:errors] = @cost.errors.full_messages
    end
    redirect_to organization_project_path(@organization, @project)
  end

  private

  def cost_params
    params.require(:cost).permit(:description)
  end

  def detect_profit_loss
    @cost = Cost.find(params[:id])
  end

  def detect_profit_loss
    @profit_loss = ProfitLoss.find(params[:profit_loss_id])
  end

  def detect_project
    @project = Project.find(params[:project_id])
  end

  def detect_organization
    @organization = Organization.find(params[:organization_id])
  end
end
