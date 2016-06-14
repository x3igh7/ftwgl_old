class AddIsByeToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :is_bye, :boolean, default: false, null: false
  end
end
