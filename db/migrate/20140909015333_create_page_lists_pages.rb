class CreatePageListsPages < ActiveRecord::Migration
  def change
    create_table :page_lists_pages do |t|
      t.integer :page_id
      t.integer :page_list_id

      t.timestamps
    end
  end
end
