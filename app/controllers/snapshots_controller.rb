require "net/http"
require "uri"
require 'base64'

class SnapshotsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def trigger
    # call the snapshot service
    url = params[:url]
    email = params[:user]

    snapshot = Snapshot.create(email: email, url: url)
    request_snapshot(snapshot)
  end

  def receive
    snapshot = Snapshot.find(params[:id])
    upload_snapshot(snapshot, Base64.decode64(params[:imageData]))
    ScreenshotMailer.result_email(snapshot).deliver
  end

  private
  def upload_snapshot(snapshot, data)
    s3 = AWS::S3.new
    bucket = s3.buckets['what-the-diff']
    key = "#{snapshot.url.gsub('/', '-')}-#{snapshot.id}.png"
    obj = bucket.objects[key]
    obj.write(data)
    obj.acl = :public_read
    base_url = "http://s3.amazonaws.com/what-the-diff/"
    snapshot.image_url = "#{base_url}#{key}"
    snapshot.save
  end

  def request_snapshot(snapshot)
    uri = URI.parse('http://grabshot.herokuapp.com/snap')
    params = {
        :format   => 'png',
        :url      => snapshot.url,
        :callback => "#{our_root_url}/snapshots/receive/#{snapshot.id}",
        :width    => 1024,
        :height   => 768
    }

    Net::HTTP.post_form(uri, params)
  end

  def our_root_url
    "http://#{request.host}:#{request.port}"
  end
end
