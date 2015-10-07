class CostsController < ApplicationController
  before_action :detect_profit_loss
  before_action :detect_cost, only: %i(show)

  def new
    @cost = Cost.new
  end

  def create
    Cost.transaction do
      @cost = Cost.create!(cost_params)
      @profit_loss.update_attributes!(cost: @cost)
    end
      flash[:message] = 'successfully created cost'
      redirect_to profit_loss_cost_path(@profit_loss, @cost)
    rescue => e
      flash[:errors] = @cost.errors.full_messages
      render :new
  end

  def index
  end

  def show
  end

  private

  def cost_params
    params.require(:cost).permit(:description, :sales)
  end

  def detect_cost
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
