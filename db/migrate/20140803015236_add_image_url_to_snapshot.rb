class AddImageUrlToSnapshot < ActiveRecord::Migration
  def change
    add_column :snapshots, :image_url, :string
  end
end
