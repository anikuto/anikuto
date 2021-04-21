# frozen_string_literal: true
class WorkMailer < ActionMailer::Base
  default from: 'Anikuto <noreply@anikuto.com>'

  def untouched_works_notification(work_ids)
    @works = Work.where(id: work_ids)

    mail(to: 'hello@anikuto.com', subject: '[Anikuto DB] Please update the unupdated works')
  end
end
