require 'thor'
require 'htcht/cli/rails/rails'

module Htcht
  # All subcommands go here
  class Main < Thor
    desc 'rails COMMANDS', 'For all your Ruby on Rails needs.'
    subcommand 'rails', Htcht::CLI::Rails::Rails
  end
end
