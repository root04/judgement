class RemoveNoneNullRestrictionFromProfitLossSalesCosts < ActiveRecord::Migration
  def change
    change_column_null :profit_losses, :sales_id, true
    change_column_null :profit_losses, :cost_id, true
  end
end
