# frozen_string_literal: true

class InternalStatisticMailer < ActionMailer::Base
  default from: 'Anikuto <noreply@anikuto.com>'

  def result_mail(date_str)
    statistcs = InternalStatistic.where(date: Date.parse(date_str))
    @data = statistcs.map do |s|
      [s.key, s.value.presence || 0]
    end
    @data = @data.to_h

    mail(to: 'hello@anikuto.com', subject: "Anikuto Statistic - #{date_str}")
  end
end
