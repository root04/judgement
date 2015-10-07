class ProfitLossesController < ApplicationController
  def new
    @profit_loss = ProfitLoss.new(project_id: params[:project_id])
  end

  def show
    @profit_loss = ProfitLoss.find(params[:id])
  end

  def create
    @profit_loss = ProfitLoss.new(profit_loss_params)

    if @profit_loss.save
      redirect_to profit_loss_path(@profit_loss)
    else
      flash[:errors] = @profit_loss.errors.full_messages
      render :new
    end
  end

  private

  def profit_loss_params
    params.require(:profit_loss).permit(:description, :project_id)
  end

end
