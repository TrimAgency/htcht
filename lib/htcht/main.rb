require 'thor'
require 'htcht/cli/rails/rails'

module Htcht

  # All subcommands go here
  class Main < Thor

    desc "rails-api", "Creates a Ruby on Rails API with the Trim Starter Template"
    subcommand "rails-api", Htcht::CLI::Rails::Rails

  end

end
