require 'htcht/helpers/general_helpers'
require 'htcht/helpers/name_helpers'
require 'htcht/helpers/git_helpers'

module Htcht
  module CLI
    module Angular
      class Angular < Thor
        include Thor::Actions
        include Htcht::Helpers::GeneralHelpers
        include Htcht::Helpers::NameHelpers
        include Htcht::Helpers::GitHelpers

        def self.source_root
          File.dirname(__FILE__)
        end

        desc 'new AppName', 'Create a new base Angular App with the Trim Template.'
        def new(appname)
          dash_name = dash_casify(appname)
          run("git clone #{ANGULAR_STARTER_URL} #{dash_name}")

          inside(dash_name) do
            gsub_file('.angular-cli.json',
                      'trim-ng2-starter',
                      dash_name)
            gsub_file('package.json',
                      'trim-ng2-starter',
                      dash_name)
            gsub_file('src/index.html',
                      'TrimNg2Starter',
                      appname)
          end
        end
      end
    end
  end
end
