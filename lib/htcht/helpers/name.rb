module Htcht
  module Helpers
    class Name

      def initialize(name)
        @name = name
      end

      def snake_case 
        name.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          gsub(/\s+/, '_').
          tr("-", "_").
          downcase
      end

      private
      attr_reader :name
    end
  end
end
