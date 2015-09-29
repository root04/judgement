class CreateSalesDetails < ActiveRecord::Migration
  def change
    create_table :sales_details do |t|
      t.string   :name
      t.string   :description
      t.date     :ordered_date
      t.date     :book_date
      t.string   :category
      t.integer  :sales
      t.string   :client
      t.references :sales, index: true
    end
  end
end
