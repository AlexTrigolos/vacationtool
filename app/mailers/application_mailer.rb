class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.default_mail_sender
  layout 'mailer'
end
