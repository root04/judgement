class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.string   :name
      t.string   :description
      t.date     :order_date
      t.string   :category
      t.integer  :cost
      t.string   :payee
      t.references :actual, index: true
    end
  end
end
