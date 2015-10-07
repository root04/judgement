class Sale < ActiveRecord::Base
  has_many :sale_details
  has_many :profit_losses
  has_many :costs, through: :profit_losses

  accepts_nested_attributes_for :profit_losses

  def term_cost(startday, endday)
    sale_details.term_cost(startday, endday)
  end
end
