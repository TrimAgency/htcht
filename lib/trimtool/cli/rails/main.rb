module Trimtool
  module CLI
    module Rails

      class Main < Thor
        include Thor::Actions

        def self.source_root
          File.dirname(__FILE__)
        end

        desc 'new APPNAME', 'Create a new base Rails App inside a Docker Container with Postgres setup as the database.'
        method_option :verbose, type: :boolean, default: false, :aliases => '-v', :desc => 'default: [--no-verbose] By default rails new will be run with the quiet flag, this turns it off.'
        method_option :api, type: :boolean, default: false, :desc => 'default: [--no-api] Generate Rails App in API mode.'
        method_option :bootstrap, type: :boolean, default: false, :desc => 'default: [--no-bootstrap] Generate a base Rails app with custom Gemfile and configs. (This along with "--api" is the base for new Rails APIs at Trim Agency).'
        def new(appname)

          # Format the appname as snake case for folders, etc.
          # This code is taken straight from Rails
          snake_name = appname.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase

          rails_new_command = 'docker-compose run app rails new . --database=postgresql --skip-bundle'

          # Use our base gemfile don't let rails generate a new one
          if options[:bootstrap] && options[:api]
            copy_file 'BootstrapGemfile', "#{snake_name}/Gemfile"
            rails_new_command.concat(' --skip')
          elsif options[:bootstrap]
            puts '--bootstrap must be used with --api... Bootstrap base rails apps soon.'
            return
          else
            copy_file 'BaseGemfile', "#{snake_name}/Gemfile"
            rails_new_command.concat(' --force')
          end

          if options[:api]
            rails_new_command.concat(' --api')
          end

          unless options[:verbose]
            rails_new_command.concat(' --quiet')
          end

          puts "Creating new Rails API with name: #{appname}"

          empty_directory(snake_name)
          copy_file 'docker-compose.yml', "#{snake_name}/docker-compose.yml"
          copy_file 'Dockerfile', "#{snake_name}/Dockerfile"

          inside(snake_name) do
            # Build the containers
            run('docker-compse build')

            # Run the command to generate a new rails app
            run(rails_new_command)

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

          end
        end
      end
    end

  end
end
