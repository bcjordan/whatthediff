require "net/http"
require "uri"
require 'base64'

class Snapshot < ActiveRecord::Base
  belongs_to :page_list_capture
end
