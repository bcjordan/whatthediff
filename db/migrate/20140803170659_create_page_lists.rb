class CreatePageLists < ActiveRecord::Migration
  def change
    create_table :page_lists do |t|

      t.timestamps
    end
  end
end
