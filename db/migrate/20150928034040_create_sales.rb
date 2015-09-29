class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.text :description
    end
  end
end
