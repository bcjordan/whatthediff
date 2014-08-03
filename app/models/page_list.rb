require 'digest/md5'

class PageList < ActiveRecord::Base
  has_many :page_list_captures

  def secret_key
    Digest::MD5.hexdigest("foobar#{id}#{ENV['USER_HASH_KEY']}")[0..5]
  end
end
