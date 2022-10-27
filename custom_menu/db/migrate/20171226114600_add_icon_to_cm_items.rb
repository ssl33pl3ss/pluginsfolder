class AddIconToCmItems < ActiveRecord::Migration[4.2]
  def change
    add_column :cm_items, :icon, :string
  end
end