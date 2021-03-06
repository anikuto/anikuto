# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start('rails')
end

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[
  Rails.root.join('spec/support/helper.rb'),
  Rails.root.join('spec/support/**/*.rb'),
  Rails.root.join('spec/steps/**/*.rb')
].sort.each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.default_max_wait_time = 5
Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # `:type` メタデータを自動で付与する
  # http://willnet.in/119
  config.infer_spec_type_from_file_location!

  # If you"re not using ActiveRecord, or you"d prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:each, type: :system) do
    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"

    Capybara.register_driver :remote_selenium_chrome do |app|
      caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        chrome_options: {
          args: %w(headless)
        }
      )

      driver = Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV.fetch('SELENIUM_DRIVER_URL'),
        desired_capabilities: caps
      )

      # https://stackoverflow.com/questions/51989015/selenium-file-detector-unable-to-find-file-to-upload-to-selenium-grid
      driver.browser.file_detector = ->(args) do
        str = args.first.to_s
        str if File.exist?(str)
      end

      driver
    end

    driven_by :remote_selenium_chrome unless ENV['NO_HEADLESS']
  end
end

RSpec::Matchers.define_negated_matcher :not_chage, :change
