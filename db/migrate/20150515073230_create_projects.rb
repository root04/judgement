class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :organization, index: true, null: false

      t.timestamps
    end
  end
end
