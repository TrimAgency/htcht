module Htcht
  module Helpers
    module VersionHelpers

      def latest_ruby
        # This is going to be hard coded for now because I can't seem to
        # find a public api for getting the latest version of Ruby
        '2.4.1'
      end

      def latest_rails
        # The rubygems.org API does allow you to get the latest version
        # of Rails but it is a private api (see above comment as well)
        '5.1.2'
      end

    end
  end
end

