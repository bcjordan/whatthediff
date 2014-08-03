class SnapshotsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def trigger
    ScreenshotMailer.result_email(params[:user], params[:url]).deliver
  end
end
