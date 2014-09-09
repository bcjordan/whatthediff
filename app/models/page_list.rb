require 'digest/md5'

class PageList < ActiveRecord::Base
  after_create :set_secret_key
  has_many :page_list_captures
  has_and_belongs_to_many :pages

  def upgrade_from_legacy
    set_urls(urls) if urls
  end

  def set_urls(url_string)
    Page.all_from_string(url_string).each do |page|
      pages << page
    end
  end

  def set_secret_key
    some_random_chars = (0...50).map { (65 + rand(26)).chr }.join
    self.secret_key = Digest::MD5.hexdigest(some_random_chars)[0..5]
    self.save
  end

  def historical_snapshots(snapshot)
    page_list_captures.order('created_at').reverse_order
      .map{|page_list_capture| page_list_capture.snapshots.find_by_url(snapshot.url)}
      .reject{|snapshot| snapshot.nil?}
  end
end
