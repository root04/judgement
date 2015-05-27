class Cost < ActiveRecord::Base
  belongs_to :date
  belongs_to :actual

  scope :with_year_month, ->(year, month) {
    where(order_date: Date.new(year, month, 1)..Date.new(year, month, -1))
  }
end
