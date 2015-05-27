class Budget < ActiveRecord::Base
  has_many :sales
  has_many :costs
end
