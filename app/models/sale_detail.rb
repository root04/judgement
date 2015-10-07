class SaleDetail < ActiveRecord::Base
  belongs_to :date
  belongs_to :sale

  scope :term_sale, ->(start, endday) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day))
  }

  scope :term_category_sale, ->(start, endday, category) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day)).where(category: category).sum(:sale_value)
  }

  scope :term_categories, ->(start, endday) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day)).pluck(:category)
  }
end
