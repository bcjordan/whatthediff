# Preview all emails at http://localhost:3000/rails/mailers/screenshot_mailer
class ScreenshotMailerPreview < ActionMailer::Preview
  def result_email
    ScreenshotMailer.result_email(Snapshot.last, Diff.last)
  end

  def result_email_diff
    Diff.last.update(different: true)
    ScreenshotMailer.result_email(Snapshot.last, Diff.last)
  end

  def result_email_no_diff
    Diff.last.update(different: false)
    ScreenshotMailer.result_email(Snapshot.last, Diff.last)
  end

  def result_email_first_snapshot
    ScreenshotMailer.first_snapshot_email(Snapshot.last)
  end

  def result_email_page_list_capture
    ScreenshotMailer.list_result_email(PageListCapture.last)
  end
end
