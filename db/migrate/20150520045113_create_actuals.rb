class CreateActuals < ActiveRecord::Migration
  def change
    create_table :actuals do |t|
      t.text :description
      t.timestamp :date
      t.references :project, index: true
    end
  end
end
