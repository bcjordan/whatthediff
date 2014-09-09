require 'test_helper'

class PageListTest < ActiveSupport::TestCase
  setup do
    @list = create(:page_list)
  end

  test 'can exist' do
    assert(@list.is_a? PageList)
  end

  test 'can have urls' do
    @list.pages << create(:page)
    assert_not_empty(@list.pages)
    assert(@list.pages.first.is_a?(Page))
  end

  test 'can generate urls from string' do
    @list.set_urls('http://google.com
      http://slashdot.org
      http://reddit.com')
    assert_equal(3, @list.pages.count)
    assert_equal('http://google.com', @list.pages.first.url)
  end

  test 'can have 50 urls' do
    urls = ''
    50.times do |n|
      urls += "http://google.com/?#{n}\n"
    end
    @list.set_urls(urls)
    assert_equal(50, @list.pages.count)
  end

  test 'can convert existing page list urls into page list' do
    legacy_list = create(:page_list)
    legacy_list.urls = "http://google.com\nhttp://reddit.com\nhttp://slashdot.org"
    legacy_list.save!
    PageList.all.each(&:upgrade_from_legacy)
    assert_equal(3, legacy_list.pages.count)
  end
end
