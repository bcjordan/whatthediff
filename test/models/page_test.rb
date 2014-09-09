require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test 'generating from string' do
    results = Page.all_from_string('http://google.com')
    assert_not_empty results
    assert_equal(1, results.length)
  end

  test 'generating multiple from string' do
    results = Page.all_from_string('
    http://google.com
    http://google.com/1
    http://google.com/2
    http://google.com/3
')
    assert_not_empty results
    assert_equal(4, results.length)
    assert(results.first.is_a? Page)
    assert_equal('http://google.com', results.first.url)
    assert_not_empty(Page.where(url: 'http://google.com'))
  end

  test 'page with url' do
    assert_equal('http://google.com', create(:page).url)
  end
end
