# frozen_string_literal: true

class AdminMailer < ActionMailer::Base
  default from: 'Anikuto <noreply@glimmerhq.com>'

  def episode_created_notification(episode_id)
    @episode = Episode.find(episode_id)

    mail(to: 'hello@glimmerhq.com', subject: 'Episode added')
  end

  def error_in_episode_generator_notification(slot_id, error_message)
    @slot = Slot.find(slot_id)
    @work = @slot.work
    @error_message = error_message

    mail(to: 'hello@glimmerhq.com', subject: 'An error occurred during episode generation')
  end
end
