class CostDetail < ActiveRecord::Base
  belongs_to :date
  belongs_to :profit_losses

  scope :term_cost, ->(start, endday) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day))
  }

  scope :term_category_cost, ->(start, endday, category) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day)).where(category: category).sum(:cost)
  }

  scope :term_categories, ->(start, endday) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day)).pluck(:category)
  }
end
