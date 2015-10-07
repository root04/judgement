class CostDetailsController < ApplicationController
  before_action :detect_profit_loss
  before_action :detect_organization
  before_action :detect_project
  before_action :detect_cost
  before_action :detect_cost_detail

  def new
    @cost_detail = CostDetail.new(cost: @cost)
  end

  def create
    @cost_detail = @cost.cost_details.new(cost_detail_params)

    unless @cost_detail.save
      flash[:errors] = @cost.errors.full_messages
    end
    redirect_to profit_loss_cost_path(@profit_loss, @cost)
  end

  private

  def detect_profit_loss
    @profit_loss = ProfitLoss.find(params[:profit_loss_id])
  end

  def cost_detail_params
    params.require(:cost_detail).permit(:name, :description, :order_date, :category, :cost_value, :payee)
  end

  def detect_cost
    @cost = Cost.find(params[:cost_id])
  end

  def detect_cost_detail
  end

  def detect_project
    @project = @profit_loss.project
  end

  def detect_organization
    @organization = @profit_loss.project.organization
  end
end
