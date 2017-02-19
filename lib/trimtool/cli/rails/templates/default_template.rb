#
# App Setup
# ----------------------------

# Set the name of the app in application.rb
gsub_file('config/application.rb', 'module App', "module #{appname}")

# Edit database.yml to work with docker
insert_into_file('config/database.yml', "\s\susername: postgres\n\s\spassword:\n\s\shost: postgres\n\s\sport: 5432\n", :after => "default: &default\n")
gsub_file('config/database.yml', 'app_development', "#{snake_name}_development")
gsub_file('config/database.yml', 'app_test', "#{snake_name}_test")
gsub_file('config/database.yml', 'app_production', "#{snake_name}_production")
gsub_file('config/database.yml', 'username: app', "username: #{snake_name}")
gsub_file('config/database.yml', 'APP_DATABASE_PASSWORD', "#{snake_name.upcase}_DATABASE_PASSWORD")

# Edit the Dockerfile and rebuild the app now that it has a Gemfile and Gemfile.lock
gsub_file('Dockerfile', 'RUN gem install rails', '#RUN gem install rails')
gsub_file('Dockerfile', '#COPY Gemfile Gemfile.lock ./', 'COPY Gemfile Gemfile.lock ./')
gsub_file('Dockerfile', '#RUN gem install bundler && bundle install --jobs 20 --retry 5', 'RUN gem install bundler && bundle install --jobs 20 --retry 5')
run('docker-compose run app bundle')
run('docker-compose build')

# Setup the database (Create and Migrate)
run('docker-compose run app rake db:create')
run('docker-compose run app rake db:migrate')
