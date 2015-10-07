class AddDescriptionToProfitLosses < ActiveRecord::Migration
  def change
    add_column :profit_losses, :description, :string, null: false, default: ''
  end
end
