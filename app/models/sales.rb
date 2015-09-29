class Sales < ActiveRecord::Base
  has_many :sales_details
  belongs_to :profit_loss

  accepts_nested_attributes_for :sales_details

  def term_cost(startday, endday)
    sales_details.term_cost(startday, endday)
  end
end
