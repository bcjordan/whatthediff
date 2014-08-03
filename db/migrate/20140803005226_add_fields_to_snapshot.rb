class AddFieldsToSnapshot < ActiveRecord::Migration
  def change
    add_column :snapshots, :url, :string
    add_column :snapshots, :email, :string
  end
end
