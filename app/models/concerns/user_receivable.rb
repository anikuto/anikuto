# frozen_string_literal: true

module UserReceivable
  extend ActiveSupport::Concern

  included do
    def receiving?(channel)
      receptions.where(channel_id: channel.id).present?
    end

    def receive(channel)
      return if receiving?(channel)

      receptions.create(channel: channel)
      CreateChannelWorksJob.perform_later(self, channel)
    end

    def unreceive(channel)
      reception = receptions.where(channel_id: channel.id).first

      return if reception.blank?

      reception.destroy
      DestroyChannelWorksJob.perform_later(self, channel)
    end
  end
end
