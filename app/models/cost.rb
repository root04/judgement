class Cost < ActiveRecord::Base
  belongs_to :date
  belongs_to :actual

  scope :term_cost, ->(start, endday) {
    where(order_date: Date.new(start.year, start.month, start.day)..Date.new(endday.year, endday.month, endday.day))
  }
end
