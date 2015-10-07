class SaleDetailsController < ApplicationController
  before_action :detect_profit_loss
  before_action :detect_organization
  before_action :detect_project
  before_action :detect_sale
  before_action :detect_sale_detail

  def new
    @sale_detail = SaleDetail.new(sale: @sale)
  end

  def create
    @sale_detail = @sale.sale_details.new(sale_detail_params)

    unless @sale_detail.save
      flash[:errors] = @sale.errors.full_messages
    end
    redirect_to profit_loss_sale_path(@profit_loss, @sale)
  end

  private

  def detect_profit_loss
    @profit_loss = ProfitLoss.find(params[:profit_loss_id])
  end

  def sale_detail_params
    params.require(:sale_detail).permit(:name, :description, :ordered_date, :category, :sale_value, :payee)
  end

  def detect_sale
    @sale = Sale.find(params[:sale_id])
  end

  def detect_sale_detail
  end

  def detect_project
    @project = @profit_loss.project
  end

  def detect_organization
    @organization = @profit_loss.project.organization
  end
end
