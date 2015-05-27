class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string   :name
      t.string   :description
      t.date     :sales_date
      t.string   :category
      t.integer  :sales
      t.string   :client
    end
  end
end
