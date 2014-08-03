class AddImageUrlToDiff < ActiveRecord::Migration
  def change
    add_column :diffs, :image_url, :string
  end
end
