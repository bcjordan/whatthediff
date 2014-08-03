class CreatePageListCaptures < ActiveRecord::Migration
  def change
    create_table :page_list_captures do |t|
      t.integer :page_list_id

      t.timestamps
    end
  end
end
