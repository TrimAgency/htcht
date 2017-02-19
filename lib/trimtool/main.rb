require 'thor'
require 'trimtool/cli/rails/rails'

module Trimtool

  # All subcommands go here
  class Main < Thor

    desc "rails COMMANDS", "For all your Ruby on Rails needs."
    subcommand "rails", Trimtool::CLI::Rails::Rails

  end

end
