class AddEmailToPageLists < ActiveRecord::Migration
  def change
    add_column :page_lists, :email, :string
  end
end
