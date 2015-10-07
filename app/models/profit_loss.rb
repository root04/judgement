class ProfitLoss < ActiveRecord::Base
  belongs_to :cost
  belongs_to :sale
  belongs_to :project
end
