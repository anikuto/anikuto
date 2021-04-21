# frozen_string_literal: true

RSpec.configure do |config|
  config.before :suite do
    ImageHelper.module_eval do
      def ann_image_url(*)
        "#{ENV.fetch('ANIKUTO_URL')}/dummy_image"
      end
    end
  end
end
