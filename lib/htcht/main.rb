require 'thor'
require 'htcht/cli/rails/rails'
require 'htcht/cli/angular/angular'

module Htcht

  # All subcommands go here
  class Main < Thor
    desc 'rails', 'Creates a Ruby on Rails API with the Trim Starter Template'
    subcommand 'rails', Htcht::CLI::Rails::Rails

    desc 'angular', 'Creates a Angular App with the Trim Starter Template'
    subcommand 'angular', Htcht::CLI::Angular::Angular
  end

end
