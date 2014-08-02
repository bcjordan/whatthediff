class ScreenshotMailer < ActionMailer::Base
  default from: "bcjordan@gmail.com"
  def result_email(email)
    mail(to: email, subject: 'Your deploy screenshot diffs')
  end
end
