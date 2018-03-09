module Htcht
  module Helpers
    module NameHelpers

      def snake_casify(name)
        name.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          gsub(/\s+/, '_').
          tr("-", "_").
          downcase
      end

      def titleize(appname)
        appname.gsub(/\w+/, &:capitalize)
      end
    end
  end
end
