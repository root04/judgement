class Cost < ActiveRecord::Base
  has_many :cost_details
  belongs_to :profit_loss

  accepts_nested_attributes_for :cost_details

  def term_cost(startday, endday)
    cost_details.term_cost(startday, endday)
  end
end
