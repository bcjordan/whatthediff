class AddPageListIdToSnapshot < ActiveRecord::Migration
  def change
    add_column :snapshots, :page_list_id, :integer
  end
end
