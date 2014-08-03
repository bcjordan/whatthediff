class Diff < ActiveRecord::Base
  def snapshot_a
    Snapshot.find(snapshot_a_id)
  end

  def snapshot_b
    Snapshot.find(snapshot_b_id)
  end
end
