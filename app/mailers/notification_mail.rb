class NotificationMail < ActionMailer::Base
  default from: "from@example.com"
  
  def response_registered(pw_response)
    @pw_response = pw_response

    mail to: pw_response.pw_request.email
  end
  
  def pw_recipient_password(pw_recipient_authentication)
    @pw_recipient_authentication = pw_recipient_authentication
    
    mail to: pw_recipient_authentication.pw_recipient.email
  end
end
