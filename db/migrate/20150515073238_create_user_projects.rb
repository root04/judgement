class CreateUserProjects < ActiveRecord::Migration
  def change
    create_table :user_projects do |t|
      t.references :user, null: false
      t.references :project, null: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end

    add_index :user_projects, [:user_id, :project_id], unique: true
    add_index :user_projects, [:project_id, :user_id]
  end
end
