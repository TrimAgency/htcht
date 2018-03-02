require 'htcht/helpers/general_helpers'
require 'htcht/helpers/name_helpers'
require 'htcht/helpers/git_helpers'

module Htcht
  module CLI
    module Rails
      class Rails < Thor
        include Thor::Actions
        include Htcht::Helpers::GeneralHelpers
        include Htcht::Helpers::NameHelpers
        include Htcht::Helpers::GitHelpers

        def self.source_root
          File.dirname(__FILE__)
        end

        desc 'new AppName', 'Create a new base Rails App inside a Docker Container with Postgres setup as the database.'
        def new(appname)
          snake_name = snake_casify(appname)
          run("git clone #{RAILS_STARTER_URL} #{snake_name}")

          inside(snake_name) do
            gsub_file('config/application.rb',
                      'module TrimStarter',
                      "module #{appname}")
            gsub_file('config/database.yml',
                      'trim_starter_development',
                      "#{snake_name}_development")
            gsub_file('config/database.yml',
                      'trim_starter_test',
                      "#{snake_name}_test")
            gsub_file('config/database.yml',
                      'trim_starter_production',
                      "#{snake_name}_production")
            gsub_file('config/database.yml',
                      'username: trim_starter',
                      "username: #{snake_name}")
            gsub_file('config/database.yml',
                      'TRIM_STARTER_DATABASE_PASSWORD',
                      "#{snake_name.upcase}_DATABASE_PASSWORD")

            run('docker-compose build')
            run('docker-compose run app rake db:create')
            run('docker-compose run app rake db:migrate')
          end
        end
      end
    end
  end
end
