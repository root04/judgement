class Cost < ActiveRecord::Base
  has_many :cost_details
  has_many :profit_losses
  has_many :sales, through: :profit_losses

  accepts_nested_attributes_for :profit_losses

  def term_cost(startday, endday)
    cost_details.term_cost(startday, endday)
  end
end
