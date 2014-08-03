class ScreenshotMailer < ActionMailer::Base
  default from: "bcjordan@gmail.com"
  def result_email(snapshot)
    email = snapshot.email
    @url = snapshot.url
    @image = snapshot.image_url
    mail(to: email, subject: 'Your deploy screenshot diffs')
  end
end
