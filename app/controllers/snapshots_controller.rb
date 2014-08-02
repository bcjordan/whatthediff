class SnapshotsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def trigger
    # params[:user]
  end
end
