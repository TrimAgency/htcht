require 'thor'
require 'htcht/cli/rails/rails'

module Htcht

  # All subcommands go here
  class Main < Thor

    desc "rails", "Creates a Ruby on Rails API with the Trim Starter Template"
    subcommand "rails", Htcht::CLI::Rails::Rails

  end

end
