# frozen_string_literal: true

class StatusUpdateMailer < ApplicationMailer
  def notify_creator(vacation)
    @vacation = vacation
    mail(to: vacation.email, subject: t('.vacation_status'))
  end
end
