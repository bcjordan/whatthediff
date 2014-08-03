class AddUrlListToPageLists < ActiveRecord::Migration
  def change
    add_column :page_lists, :urls, :string
  end
end
