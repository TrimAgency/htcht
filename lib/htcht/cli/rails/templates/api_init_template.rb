def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# Clean up Gemfile
# remove commented lines
gsub_file("Gemfile", /#.*\n/, '')

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
  gem 'rubocop', require: false
end

gem_group :test do
  gem 'simplecov', :require => false
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Setup the app config
appname = "set_appname"
snake_name = "set_snake_name"

# Set the name of the app in application.rb
gsub_file('config/application.rb', 'module App', "module #{appname}")

# Edit database.yml to work with docker
insert_into_file('config/database.yml', "\s\susername: postgres\n\s\spassword:\n\s\shost: postgres\n\s\sport: 5432\n", :after => "default: &default\n")
gsub_file('config/database.yml', 'app_development', "#{snake_name}_development")
gsub_file('config/database.yml', 'app_test', "#{snake_name}_test")
gsub_file('config/database.yml', 'app_production', "#{snake_name}_production")
gsub_file('config/database.yml', 'username: app', "username: #{snake_name}")
gsub_file('config/database.yml', 'APP_DATABASE_PASSWORD', "#{snake_name.upcase}_DATABASE_PASSWORD")

run('bundle install')

# Setup Rspec for Testing
# ----------------------------
run('rails generate rspec:install')

# Setup Figaro for ENV
# ----------------------------
run('bundle exec figaro install')

# Setup Knock for JWT
# ----------------------------
run('rails generate knock:install')
run('rails generate knock:token_controller user')
insert_into_file("app/controllers/application_controller.rb", "\s\sinclude Knock::Authenticable\n", :after => "class ApplicationController < ActionController::API\n")

# Generate User Model
# and add validations to user.rb
# ----------------------------
generate(:model, 'User', 'email:uniq:index', 'password:digest')
user_migration = Dir.glob('db/migrate/*.rb')[0].to_s
gsub_file(user_migration, 't.string :email', 't.string :email, null: false')
gsub_file(user_migration, 't.string :password_digest', 't.string :password_digest, null: false')

insert_into_file('app/models/user.rb', after: 'has_secure_password') do
%q(

  validates :email,
            uniqueness: { case_sensitive: false },
            presence: true,
            email: true

  validates :password,
            length: { minimum: 8 },
            confirmation: true

  validates :password_confirmation,
            presence: true

  def generate_token
    Knock::AuthToken.new(payload: { sub: id }).token
  end
)
end

# Copy remaining files to their respective locations
# ----------------------------
remove_file('spec/models/user_spec.rb')
copy_file('build_files/user_spec.rb', 'spec/models/user_spec.rb')
copy_file('build_files/users.rb', 'spec/factories/users.rb')
copy_file('build_files/email_validator.rb', 'app/validators/email_validator.rb')
copy_file('build_files/factory_girl.rb', 'spec/support/factory_girl.rb')
copy_file('build_files/rails_helper.rb', 'spec/rails_helper.rb')
copy_file('build_files/shoulda_matchers.rb', 'spec/support/shoulda_matchers.rb')
copy_file('build_files/seeds.rb', 'db/seeds.rb')
copy_file('build_files/active_model_serializers.rb', 'config/initializers/active_model_serializers.rb')
copy_file('build_files/.rubocop.yml', '.rubocop.yml')
empty_directory('db/seeds')
empty_directory('db/seeds/development')
empty_directory('db/seeds/test')
