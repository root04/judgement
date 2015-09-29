class ProfitLoss < ActiveRecord::Base
  has_many :costs
  has_many :sales
  belongs_to :project
end
