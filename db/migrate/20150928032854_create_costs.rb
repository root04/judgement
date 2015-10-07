class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.text :description
    end
  end
end
