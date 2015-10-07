class CreateProfitLosses < ActiveRecord::Migration
  def change
    create_table :profit_losses do |t|
      t.references :project, null: false, index: true
      t.references :sales, null: false, index: true
      t.references :cost, null: false, index: true
    end

    add_index :profit_losses, [:sales_id, :cost_id]
    add_index :profit_losses, [:cost_id, :sales_id]
  end
end
