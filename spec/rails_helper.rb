# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/email/rspec'
require 'view_component/test_helpers'
require 'active_storage_validations/matchers'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

require 'capybara/rspec'
Rails.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryBot::Syntax::Methods
  config.include ApplicationHelper
  config.include RequestHelper
  config.include SystemHelper


  #全てのテストにaggregate_failuresを適用する（ブロックまとめて書いても全部実行する）
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end

  config.include ActiveStorageValidations::Matchers

  config.include ViewComponent::TestHelpers, type: :component
  config.include ActionView::RecordIdentifier

  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome
  end

  # sorcery gem のhelper
  config.include Sorcery::TestHelpers::Rails::Request, type: :request
  config.include Sorcery::TestHelpers::Rails::Integration, type: :system
end
# shoulda matcherを入れる
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
# トグルSWやモーダルなどで非表示になっているものをtestするため
Capybara.ignore_hidden_elements = false

# Capybaraのdriverを指定してみる(デフォルトは:rack_test)
Capybara.default_driver = :rack_test
# jsオプション有効時のドライバを設定(デフォルトは:selenium)
Capybara.javascript_driver = :selenium

#任意の場所でScreenshotを撮るために用意する
def take_screenshot
  page.save_screenshot "tmp/capybara/screenshot-#{DateTime.now}.png"
end
#ページをリロードするヘルパーメソッドを用意する
def reload_page
  visit current_path
end
