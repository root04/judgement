class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false, limit: 255
      t.text :description
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
