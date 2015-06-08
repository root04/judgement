class Actual < ActiveRecord::Base
  has_many :costs
  belongs_to :project

  accepts_nested_attributes_for :costs

  def term_cost(startday, endday)
    costs.term_cost(startday, endday)
  end
end
