class CreateUserOrganizations < ActiveRecord::Migration
  def change
    create_table :user_organizations do |t|
      t.references :user, null: false
      t.references :organization, null: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end

    add_index :user_organizations, [:user_id, :organization_id], unique: true
    add_index :user_organizations, [:organization_id, :user_id]
  end
end
