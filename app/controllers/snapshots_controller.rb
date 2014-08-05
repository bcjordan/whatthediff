require "net/http"
require "uri"
require 'base64'

class SnapshotsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def trigger_list_capture_secret
    @page_list = PageList.where(secret_key: params[:secret_key]).first
    @page_list_capture = PageListCapture.create(page_list_id: @page_list.id)
    @page_list_capture.snapshots_for_urls.each{|snapshot| request_snapshot(snapshot)}
    redirect_to snapshots_dashboard_url(@page_list.secret_key), :notice => 'Triggered capture. Watch for email.'
  end

  def trigger_list_capture_api_secret
    @page_list = PageList.where(secret_key: params[:secret_key]).first
    @page_list_capture = PageListCapture.create(page_list_id: @page_list.id)
    @page_list_capture.snapshots_for_urls.each{|snapshot| request_snapshot(snapshot)}
    head :ok
  end

  def trigger_list_capture
    @page_list = PageList.find(params[:list_id])
    @page_list_capture = PageListCapture.create(page_list_id: @page_list.id)
    @page_list_capture.snapshots_for_urls.each{|snapshot| request_snapshot(snapshot)}
  end

  def dashboard
    @page_list = PageList.where(secret_key: params[:secret_key]).first
  end

  def trigger
    # call the snapshot service
    url = params[:url]
    email = params[:user]
    @page_list = nil
    pagelists = PageList.where(email: email)
    if (pagelists.count > 0)
      @page_list = pagelists.first
    end
    @page_list ||= PageList.create(email: email, urls: "#{url}")
    @page_list_capture = PageListCapture.create(page_list_id: @page_list.id)
    @page_list_capture.snapshots_for_urls.each{|snapshot| request_snapshot(snapshot)}
  end

  def receive
    snapshot = Snapshot.find(params[:id])
    snapshot.image_url = upload_public_file(snapshot_filename(snapshot), Base64.decode64(params[:imageData]))
    snapshot.save
    snapshots = Snapshot.where(url: snapshot.url).order("created_at").reverse_order.limit(2)
    if snapshot.page_list_capture && snapshots.count == 1
      if snapshot.page_list_capture.snapshots_all_ready?
        ScreenshotMailer.first_page_list_capture_email(snapshot.page_list_capture).deliver
        return
      end
    end
    if snapshots.count == 1
      ScreenshotMailer.first_snapshot_email(snapshot).deliver
      return
    end

    snapshotA = snapshot
    snapshotB = snapshots.second
    diff = Diff.create(snapshot_a_id: snapshotA.id, snapshot_b_id: snapshotB.id)
    if snapshot.page_list_capture
      diff.page_list_capture = snapshot.page_list_capture
      diff.save
    end
    request_diff(diff)
  end

  def receive_diff
    diff = Diff.find(params[:id])
    diff.image_url = upload_public_file(diff_filename(diff), Base64.decode64(params[:imageData]))
    diff.different = params[:diffFound] == true
    diff.save
    if diff.page_list_capture && diff.page_list_capture.diffs_all_ready?
      ScreenshotMailer.list_result_email(diff.page_list_capture).deliver
    end
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
