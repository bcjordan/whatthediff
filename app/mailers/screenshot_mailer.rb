class ScreenshotMailer < ActionMailer::Base
  include ActionView::Helpers::DateHelper

  default from: "bcjordan@gmail.com"
  def result_email(snapshot)
    @snapshots = Snapshot.where(url: snapshot.url).order("created_at").reverse_order.limit(3)
    mail(to: snapshot.email, subject: 'Your deploy screenshot diffs')
  end
end
