class RenameSalesDetailsTableToSaleDetails < ActiveRecord::Migration
  def change
    rename_table :sales_details, :sale_details
  end
end
