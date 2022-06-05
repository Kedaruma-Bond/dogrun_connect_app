require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
# capybara内のmethodを読み込む
require 'capybara/rspec'

# logger
Rails.logger = Logger.new($stdout)
ActiveRecord::Base.logger = Logger.new($stdout)

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# spec内で共有したい処理はspec/support/helperディレクトリ配下にモジュールを作成
# initialize時に読み込む設定ファイルはspec/support/configディレクトリ配下に作成
Dir[Rails.root.join('spec/support/config/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/helper/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # config.use_transactional_fixtures = false
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end

  config.include ApplicationHelper
  # signup_pathがundefinedと言われたので入れてみた
  config.include Rails.application.routes.url_helpers
  # 強制的にCapybara::DSLを読み込む
  config.include Capybara::DSL

  # 作成したテストヘルパーを追加
  config.include TestHelper
  config.include SystemHelper

  # 全てのテストにaggregate_failuresを適用する（ブロックまとめて書いても全部実行する）
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end
# config.include ◯◯(モジュール名), type: :☓☓(使用するテストのタイプ)

# トグルSWやモーダルなどで非表示になっているものをtestするため
Capybara.ignore_hidden_elements = false

# Capybaraのdriverを指定してみる(デフォルトは:rack_test)
Capybara.default_driver = :rack_test
# jsオプション有効時のドライバを設定(デフォルトは:selenium)
Capybara.javascript_driver = :selenium
