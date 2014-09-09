require 'uri'

class Page < ActiveRecord::Base
  has_and_belongs_to_many :page_lists

  def self.all_from_string(newline_separated_urls)
    [].tap do |all_pages|
      newline_separated_urls.split(/\n/).map(&:strip).reject(&:nil?).each do |url|
        all_pages << Page.create(url: url) if valid_url?(url)
      end
    end
  end

  private

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end
