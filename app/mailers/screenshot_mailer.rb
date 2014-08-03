class ScreenshotMailer < ActionMailer::Base
  include ActionView::Helpers::DateHelper

  default from: "bcjordan@gmail.com"
  def result_email(snapshot, diff = nil)
    @diff = diff
    @snapshots = Snapshot.where(url: snapshot.url).order("created_at").reverse_order.limit(3)
    @different = @diff && @diff.different
    subject = @different ? "Difference detected on page #{@diff.snapshot_a.url}" : 'No differences detected, latest snapshots'
    mail(to: snapshot.email, subject: subject)
  end

  def first_snapshot_email(snapshot)
    @snapshot = snapshot
    mail(to: snapshot.email, subject: 'Your first screenshot is ready!')
  end
end
