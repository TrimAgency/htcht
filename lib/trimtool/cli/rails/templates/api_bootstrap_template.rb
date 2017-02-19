# Install Gems
# ----------------------------
gem 'rails'
gem 'pg'
gem 'puma'
gem 'bcrypt'
gem 'rack-cors'
gem 'active_model_serializers'
gem 'jwt'
gem 'knock'
gem 'cancancan'
gem 'rolify'
gem 'seedbank'
gem 'figaro'

gem_group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-clipboard'
  gem 'pry-doc'
  gem 'pry-docmore'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-rails'
  gem 'shoulda-matchers'
end

gem_group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

gem_group :test do
  gem 'simplecov', :require => false
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

