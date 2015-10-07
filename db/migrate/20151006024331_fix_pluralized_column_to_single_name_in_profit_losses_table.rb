class FixPluralizedColumnToSingleNameInProfitLossesTable < ActiveRecord::Migration
  def change
    rename_column :profit_losses, :sales_id, :sale_id
  end
end
