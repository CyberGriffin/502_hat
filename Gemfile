source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "bootsnap", require: false
gem 'bootstrap', '~> 5.1.3'
gem 'devise'
gem "importmap-rails"
gem "jbuilder"
gem 'jquery-rails'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.3"
gem 'rexml'
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
     # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
     gem "debug", platforms: %i[ mri mingw x64_mingw ]
     gem 'rspec-rails'
end

group :development do
     # Use console on exceptions pages [https://github.com/rails/web-console]
     gem "web-console"

     # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
     # gem "rack-mini-profiler"

     # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
     # gem "spring"
end

group :test do
     # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
     gem "capybara"
     gem "codecov", require: false
     gem "selenium-webdriver"
     gem "webdrivers"
end

gem "brakeman"
gem "dotenv-rails", "~> 3.1"
gem "rubocop"
gem "rubocop-rails"
