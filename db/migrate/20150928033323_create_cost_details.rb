class CreateCostDetails < ActiveRecord::Migration
  def change
    create_table :cost_details do |t|
      t.string   :name
      t.string   :description
      t.date     :order_date
      t.string   :category
      t.integer  :cost
      t.string   :payee
      t.references :cost, index: true
    end
  end
end
