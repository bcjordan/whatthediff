require "net/http"
require "uri"

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
    upload_snapshot(snapshot, params[:imageData])
    ScreenshotMailer.result_email(snapshot).deliver
  end

  private
  def upload_snapshot(snapshot, data)
    s3 = AWS::S3.new
    bucket = s3.buckets['what-the-diff']
    obj = bucket.objects["#{snapshot.url.gsub('/','-')}-#{snapshot.id}.png"]
    obj.write(data)
    snapshot.image_url = obj.url_for(:read)
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
