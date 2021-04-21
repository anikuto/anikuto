# frozen_string_literal: true

namespace :vod do
  task import: :environment do
    [
      Anikuto::VodImporter::BandaiChannel,
      Anikuto::VodImporter::NicoNicoChannel,
      Anikuto::VodImporter::DAnimeStore,
      Anikuto::VodImporter::AmazonVideo
    ].each(&:import)
  end
end
