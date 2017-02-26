module Trimtool
  module CLI
    module Rails

      class Rails < Thor
        include Thor::Actions

        def self.source_root
          File.dirname(__FILE__)
        end

        desc 'new AppName', 'Create a new base Rails App inside a Docker Container with Postgres setup as the database.'
        method_option :verbose, type: :boolean, default: false, :aliases => '-v', :desc => 'default: [--no-verbose] By default rails new will be run with the quiet flag, this turns it off.'
        method_option :api, type: :boolean, default: false, :desc => 'default: [--no-api] Generate Rails App in API mode.'
        method_option :bootstrap, type: :boolean, default: false, :desc => 'default: [--no-bootstrap] Generate a base Rails app with custom Gemfile and configs. (This along with "--api" is the base for new Rails APIs at Trim Agency).'
        method_option :test, type: :boolean, default: false, :desc => 'default: [--no-test]'
        def new(appname)

          # Format the appname as snake case for folders, etc.
          # This code is taken straight from Rails
          snake_name = appname.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase

          rails_new_command = 'docker-compose run app rails new . --database=postgresql -T --skip-bundle'

          # Set the application template
          # TODO: Refactor to be dynamic from a directory
          if options[:bootstrap] && options[:api]
            copy_file('templates/api_bootstrap_template.rb', "#{snake_name}/api_bootstrap_template.rb")
            copy_file('templates/api_build_files/user_spec.rb', "#{snake_name}/build_files/user_spec.rb")
            copy_file('templates/api_build_files/users.rb', "#{snake_name}/build_files/users.rb")
            copy_file('templates/api_build_files/email_validator.rb', "#{snake_name}/build_files/email_validator.rb")
            copy_file('templates/api_build_files/factory_girl.rb', "#{snake_name}/build_files/factory_girl.rb")
            copy_file('templates/api_build_files/shoulda_matchers.rb', "#{snake_name}/build_files/shoulda_matchers.rb")
            copy_file('templates/api_build_files/rails_helper.rb', "#{snake_name}/build_files/rails_helper.rb")
            rails_new_command.concat(' -m api_bootstrap_template.rb')
          elsif options[:bootstrap]
            puts "--bootstrap must be used with --api for now. This is on it's way"
            return
          else
            copy_file 'templates/default_template.rb', "#{snake_name}/default_template.rb"
            rails_new_command.concat(' -m default_template.rb')
          end

          # Copy this over so that Docker can run Rails new
          copy_file 'BaseGemfile', "#{snake_name}/Gemfile"
          rails_new_command.concat(' --force')

          if options[:api]
            rails_new_command.concat(' --api')
          end

          unless options[:verbose]
            rails_new_command.concat(' --quiet')
          end

          puts "Creating new Rails API with name: #{appname}"

          if options[:test]
            puts "Here is the command:"
            puts rails_new_command
            return
          end

          empty_directory(snake_name)
          copy_file('docker-compose.yml', "#{snake_name}/docker-compose.yml")
          copy_file('Dockerfile', "#{snake_name}/Dockerfile")

          inside(snake_name) do

            # Build the containers
            run('docker-compse build')

            # Run the command to generate a new rails app
            run(rails_new_command)

            # Edit the Dockerfile and rebuild the app now that it has a Gemfile and Gemfile.lock
            gsub_file('Dockerfile', 'RUN gem install rails', '#RUN gem install rails')
            gsub_file('Dockerfile', '#COPY Gemfile Gemfile.lock ./', 'COPY Gemfile Gemfile.lock ./')
            gsub_file('Dockerfile', '#RUN gem install bundler && bundle install --jobs 20 --retry 5', 'RUN gem install bundler && bundle install --jobs 20 --retry 5')
            run('docker-compose build')

            run('docker-compose run app rake db:create')
            run('docker-compose run app rake db:migrate')

          end
        end
      end
    end

  end
end