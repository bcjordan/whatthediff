class AddDifferentToDiff < ActiveRecord::Migration
  def change
    add_column :diffs, :different, :boolean
  end
end
