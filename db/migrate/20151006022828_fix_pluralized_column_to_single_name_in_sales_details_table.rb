class FixPluralizedColumnToSingleNameInSalesDetailsTable < ActiveRecord::Migration
  def change
    rename_column :sales_details, :sales, :sale_value
    rename_column :sales_details, :sales_id, :sale_id
  end
end
