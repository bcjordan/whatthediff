require "net/http"
require "uri"
require 'base64'

class SnapshotsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def trigger_list_capture_secret
    page_list = PageList.where(secret_key: params[:secret_key]).first
    page_list_capture = PageListCapture.create(page_list_id: page_list.id)
    page_list_capture.make_snapshot_and_diff_objects.each{|snapshot| request_snapshot(snapshot)}
    redirect_to snapshots_dashboard_url(page_list.secret_key), :notice => "Triggered capture. Watch for your email results at #{page_list.email}."
  end

  def trigger_list_capture_api_secret
    page_list = PageList.where(secret_key: params[:secret_key]).first
    page_list_capture = PageListCapture.create(page_list_id: page_list.id)
    page_list_capture.make_snapshot_and_diff_objects.each{|snapshot| request_snapshot(snapshot)}
    head :ok
  end

  def trigger_list_capture
    @page_list = PageList.find(params[:list_id])
    unless @page_list.page_list_captures.count == 0
      redirect_to root_url, :notice => 'Already captured your first snapshots. Check your email for results.'
    end
    page_list_capture = PageListCapture.create(page_list: @page_list)
    page_list_capture.make_snapshot_and_diff_objects.each{|snapshot| request_snapshot(snapshot)}
  end

  def dashboard
    @page_list = PageList.where(secret_key: params[:secret_key]).first
  end

  def trigger_heroku
    url = params[:url]
    email = params[:user]
    page_list = PageList.find_by_email(email) || PageList.create(email: email, urls: "#{url}")
    PageListCapture.create(page_list_id: page_list.id).make_snapshot_and_diff_objects.each{|snapshot| request_snapshot(snapshot)}
    head :ok
  end

  def receive_snapshot
    snapshot = Snapshot.find(params[:id])
    snapshot.image_url = upload_public_file(snapshot_filename(snapshot), Base64.decode64(params[:imageData]))
    snapshot.save

    current_capture = snapshot.page_list_capture
    throw 'Snapshot is an orphan' unless current_capture

    if current_capture.is_first_capture? && current_capture.snapshots_all_ready?
      ScreenshotMailer.first_page_list_capture_email(current_capture).deliver
      head(:ok) and return
    end

    same_url_snapshots = current_capture.page_list.historical_snapshots(snapshot)

    if same_url_snapshots.length == 1
      head(:ok) and return
    end

    throw 'Snapshots out of order' unless snapshot == same_url_snapshots.first

    snapshotA = snapshot
    snapshotB = same_url_snapshots.second

    diff = Diff.where(snapshot_a_id: snapshotA.id, snapshot_b_id: snapshotB.id, page_list_capture: current_capture).first

    throw 'Diff not found for multiple snapshots' unless diff

    request_diff(diff)
    head(:ok)
  end

  def receive_diff
    diff_id = params[:id]
    difference_found = params[:diffFound]
    image_data = params[:imageData]

    diff = Diff.find(diff_id)
    throw 'Diff is an orphan' unless diff.page_list_capture

    diff.image_url = upload_public_file(diff_filename(diff), Base64.decode64(image_data))
    diff.different = difference_found
    diff.save

    if diff.page_list_capture.diffs_all_ready?
      ScreenshotMailer.list_result_email(diff.page_list_capture).deliver and head(:ok) and return
    end

    head(:ok)
  end

  def snapshot_filename(snapshot)
    "#{snapshot.url.gsub('/', '-')}-#{snapshot.id}.png"
  end

  def diff_filename(diff)
    "#{diff.snapshot_a.url.gsub('/', '-')}-#{diff.snapshot_b.id}-diff.png"
  end

  private
  def upload_public_file(filename, data)
    s3 = AWS::S3.new
    bucket = s3.buckets['what-the-diff']
    obj = bucket.objects[filename]
    obj.write(data)
    obj.acl = :public_read
    base_url = "http://s3.amazonaws.com/what-the-diff/"
    "#{base_url}#{filename}"
  end

  def request_snapshot(snapshot)
    uri = URI.parse('http://grabbalicious.herokuapp.com/snap')
    params = {
        :format   => 'png',
        :url      => snapshot.url,
        :callback => "#{our_root_url}/snapshots/receive/#{snapshot.id}",
        :width    => 1024,
        :height   => 768
    }

    Net::HTTP.post_form(uri, params)
  end

  def request_diff(diff)
    uri = URI.parse('http://grabbalicious.herokuapp.com/diff')
    params = {
        :url_a => diff.snapshot_a.image_url,
        :url_b => diff.snapshot_b.image_url,
        :callback => "#{our_root_url}/diffs/receive/#{diff.id}"
    }

    Net::HTTP.post_form(uri, params)
  end

  def our_root_url
    "http://#{request.host}:#{request.port}"
  end
end
