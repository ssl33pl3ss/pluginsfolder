class AddUpdatedOnToJournals < ActiveRecord::Migration[4.2]
  def up
    add_column :journals, :updated_on, :datetime

    Journal.update_all('updated_on = created_on')

    add_index :journals, [:updated_on], unique: false
  end

  def down
    remove_column :journals, :updated_on
  end
end