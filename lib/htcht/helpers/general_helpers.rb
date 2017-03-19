module Htcht
  module Helpers

    module GeneralHelpers

      def docker_running?
        #TODO: look for a better way to do this
        system('docker ps')
      end
    end
  end
end
