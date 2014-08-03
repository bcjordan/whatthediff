class ScreenshotMailer < ActionMailer::Base
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper

  default from: "bcjordan@gmail.com"
  def result_email(snapshot, diff = nil)
    @diff = diff
    @snapshots = Snapshot.where(url: snapshot.url).order("created_at").reverse_order.limit(3)
    @different = @diff && @diff.different
    subject = @different ? "Difference detected on page #{@diff.snapshot_a.url}" : 'No differences detected, latest snapshots'
    mail(to: snapshot.email, subject: subject)
  end

  def list_result_email(page_list_capture)
    @page_list_capture = page_list_capture
    subject = @page_list_capture.has_diff? ?
        "#{@page_list_capture.diff_count} page #{pluralize(@page_list_capture.diff_count, 'differences')} detected" :
        'No differences detected'
    mail(to: @page_list_capture.page_list.email, subject: subject)
  end

  def first_snapshot_email(snapshot)
    @snapshot = snapshot
    mail(to: snapshot.email, subject: 'Your first screenshot is ready!')
  end
end
