# frozen_string_literal: true

if Rails.env.test?
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  }
else
  require 'shrine/storage/s3'

  s3_options = {
    access_key_id: ENV.fetch('S3_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('S3_SECRET_ACCESS_KEY'),
    endpoint: ENV.fetch('S3_ENDPOINT'),
    bucket: ENV.fetch('S3_BUCKET_NAME'),
    region: 'us-east-1',
    force_path_style:  true
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'shirne/cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'shrine', **s3_options)
  }
end

Shrine.logger = Rails.logger

Shrine.plugin :activerecord
Shrine.plugin :backgrounding
Shrine.plugin :instrumentation
Shrine.plugin :determine_mime_type
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
