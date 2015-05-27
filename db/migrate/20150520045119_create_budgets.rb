class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string   :branch_name
      t.string   :version
      t.string   :origin_branch
      t.string   :origin_version
    end
  end
end
