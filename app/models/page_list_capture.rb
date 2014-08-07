class PageListCapture < ActiveRecord::Base
  belongs_to :page_list
  has_many :snapshots
  has_many :diffs

  def make_snapshot_and_diff_objects
    list = []
    url_list = page_list.urls.split(/\r?\n/)
    url_list.each do |url|
      snapshot = Snapshot.create(email: page_list.email, url: url, page_list_capture: self)
      same_page_snapshots = page_list.historical_snapshots(snapshot)
      if same_page_snapshots.length > 1
        Diff.create(snapshot_a_id: snapshot.id,
                    snapshot_b_id: same_page_snapshots.second.id,
                    page_list_capture: self)

      end
      list << snapshot
    end
    list
  end

  def is_first_capture?
    page_list.page_list_captures.count == 1
  end

  def diffs_all_ready?
    diffs.all? {|diff| diff.image_url.present? }
  end

  def snapshots_all_ready?
    snapshots.all? {|snapshot| snapshot.image_url.present? }
  end

  def ready_snapshots
    snapshots.select{|snapshot| snapshot.image_url.present?}
  end

  def has_diff?
    diffs.any? {|diff| diff.different }
  end

  def different_diffs
    diffs.select {|diff| diff.different }
  end

  def diff_count
    diffs.where(different: true).count
  end
end
