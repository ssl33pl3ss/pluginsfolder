class MoveCmAdminToVisibility < ActiveRecord::Migration[4.2]
  def up
    CmItem.update_all("visibility = case when admin = #{CmItem.connection.quoted_true} then #{CmItem::VISIBILITY_ADMIN} else visibility end")
    remove_column :cm_items, :admin
  end
end