class Diff < ActiveRecord::Base
  belongs_to :page_list_capture

  def snapshot_a
    Snapshot.find(snapshot_a_id)
  end

  def snapshot_b
    Snapshot.find(snapshot_b_id)
  end
end
