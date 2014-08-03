class PageListCapture < ActiveRecord::Base
  belongs_to :page_list
  has_many :snapshots
  has_many :diffs

  def snapshots_for_urls
    list = []
    url_list = page_list.urls.split(/\r?\n/)
    url_list.each do |url|
      snapshot = Snapshot.create(email: page_list.email, url: url)
      snapshot.page_list_capture_id = self.id
      snapshot.save
      list << snapshot
    end
    list
  end

  def diffs_all_ready?
    snapshots.count == diffs.count && diffs.all? {|diff| diff.image_url.present? }
  end

  def snapshots_all_ready?
    snapshots.all? {|snapshot| snapshot.image_url.present? }
  end

  def has_ready_screenshots?
    snapshots.any? {|snapshot| snapshot.image_url.present? }
  end

  def ready_screenshots
    snapshots.select{|snapshot| snapshot.image_url.present?}
  end

  def has_diff?
    diffs.any? {|diff| diff.different }
  end

  def diff_count
    diffs.count {|diff| diff.different }
  end
end
