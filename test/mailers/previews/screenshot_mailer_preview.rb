# Preview all emails at http://localhost:3000/rails/mailers/screenshot_mailer
class ScreenshotMailerPreview < ActionMailer::Preview
  def result_email()
    ScreenshotMailer.result_email(Snapshot.last, Diff.last)
  end
end
