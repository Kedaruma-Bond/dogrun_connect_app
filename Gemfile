source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.0.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", github: "hotwired/turbo-rails", branch: "main"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails', '~>1.2.1'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis'
# gem 'redis-actionpack'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# ログイン機能
gem 'sorcery'
# i18n
gem 'rails-i18n'
# フォームを簡単に書く
gem 'simple_form'
# enum使う
gem 'enum'
gem 'enum_help'
# emailのformat validation
gem 'validates_email_format_of'
# decorator
gem 'active_decorator'
# sitemap generatorでSEO対策
gem 'sitemap_generator'
# 画像ストレージ先
gem 'cloudinary'
# chart作図
gem 'chartkick'
# pagination
gem 'kaminari'
gem 'pagy'
# 検索機能
gem 'ransack'
# meta tag管理
gem 'meta-tags'
# aws接続用
gem 'aws-sdk-s3'
# rails to js
gem 'gon'
# Active Storage validation追加
gem 'active_storage_validations'
# 都道府県データ
gem 'jp_prefecture'
# view componentのカプセル化
gem 'view_component'
# 定期実行プロセス用
gem 'clockwork', '~> 3.0.1'
# heroku addon
# app performance monitoring
gem 'scout_apm'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'annotate'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'webdrivers'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  gem "debug", git: 'https://github.com/ruby/debug', branch: 'master'
  # error詳細確認用
  gem 'better_errors'
  gem 'binding_of_caller'
  # code補完
  gem 'solargraph'
  # 模擬メール機能
  gem 'letter_opener_web'
  # favicon生成
  gem 'rails_real_favicon'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end
