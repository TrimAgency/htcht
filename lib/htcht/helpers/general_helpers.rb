module Htcht
  module Helpers

    class GeneralHelpers

      def docker_running?
        system('docker info')
      end
    end
  end
end
