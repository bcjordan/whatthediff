class ScreenshotMailer < ActionMailer::Base
  default from: "bcjordan@gmail.com"
  def result_email(snapshot)
    email = snapshot.email
    @url = snapshot.url
    mail(to: email, subject: 'Your deploy screenshot diffs')
  end
end
