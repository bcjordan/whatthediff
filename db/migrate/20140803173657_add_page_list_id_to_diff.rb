class AddPageListIdToDiff < ActiveRecord::Migration
  def change
    add_column :diffs, :page_list_id, :integer
  end
end
