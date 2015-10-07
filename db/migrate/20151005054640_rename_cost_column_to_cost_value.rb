class RenameCostColumnToCostValue < ActiveRecord::Migration
  def change
    rename_column :cost_details, :cost, :cost_value
  end
end
