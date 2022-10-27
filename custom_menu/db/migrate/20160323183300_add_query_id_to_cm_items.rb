class AddQueryIdToCmItems < ActiveRecord::Migration[4.2]
  def change
    add_column :cm_items, :query_id, :integer
  end
end