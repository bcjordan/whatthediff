class AddSnapshotsToDiff < ActiveRecord::Migration
  def change
    add_column :diffs, :snapshot_a_id, :integer
    add_column :diffs, :snapshot_b_id, :integer
  end
end
