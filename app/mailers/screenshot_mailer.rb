class ScreenshotMailer < ActionMailer::Base
  default from: "bcjordan@gmail.com"
  def result_email(email, url)
    @url = url
    mail(to: email, subject: 'Your deploy screenshot diffs')
  end
end
