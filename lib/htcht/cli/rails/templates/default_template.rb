def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

# Install Gems
# ----------------------------
gem 'pg'

# Setup the app config
appname = 'set_appname'
snake_name = 'set_snake_name'

# Set the name of the app in application.rb
gsub_file('config/application.rb', 'module App', "module #{appname}")

# Edit database.yml to work with docker
insert_into_file('config/database.yml',
                 "\s\susername: postgres\n\s\spassword:\n\s\shost: " \
                 "postgres\n\s\sport: 5432\n", after: "default: &default\n")
gsub_file('config/database.yml', 'app_development', "#{snake_name}_development")
gsub_file('config/database.yml', 'app_test', "#{snake_name}_test")
gsub_file('config/database.yml', 'app_production', "#{snake_name}_production")
gsub_file('config/database.yml', 'username: app', "username: #{snake_name}")
gsub_file('config/database.yml', 'APP_DATABASE_PASSWORD',
          "#{snake_name.upcase}_DATABASE_PASSWORD")

run('bundle install')
