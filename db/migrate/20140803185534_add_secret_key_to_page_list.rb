class AddSecretKeyToPageList < ActiveRecord::Migration
  def change
    add_column :page_lists, :secret_key, :string
  end
end
