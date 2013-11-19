class NotificationMail < ActionMailer::Base
  default from: "from@example.com"
  
  def response_registered(pw_response)
    @pw_response = pw_response

    mail to: pw_response.pw_request.email
  end
end
