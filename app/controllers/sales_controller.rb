class SalesController < ApplicationController
  before_action :detect_profit_loss
  before_action :detect_sale, only: %i(show)

  def new
    @sale = Sale.new
  end

  def create
    Cost.transaction do
      @sale = Sale.create!(sale_params)
      @profit_loss.update_attributes!(sale: @sale)
    end
      flash[:message] = 'successfully created sale'
      redirect_to profit_loss_sale_path(@profit_loss, @sale)
    rescue => e
      flash[:errors] = @sale.errors.full_messages
      render :new
  end

  def index
  end

  def show
  end

  private

  def sale_params
    params.require(:sale).permit(:description, :costs)
  end

  def detect_profit_loss
    @profit_loss = ProfitLoss.find(params[:profit_loss_id])
  end

  def detect_sale
    @sale = Sale.find(params[:id])
  end
end
