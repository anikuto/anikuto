# frozen_string_literal: true
class WorkMailer < ActionMailer::Base
  default from: 'Anikuto <noreply@glimmerhq.com>'

  def untouched_works_notification(work_ids)
    @works = Work.where(id: work_ids)

    mail(to: 'hello@glimmerhq.com', subject: '[Anikuto DB] Please update the unupdated works')
  end
end
