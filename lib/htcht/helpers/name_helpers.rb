module Htcht
  module Helpers
    # Helpers related to naming
    # string manipulation, etc.
    module NameHelpers
      def snake_casify(name)
        name.gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .gsub(/\s+/, '_')
            .tr('-', '_')
            .downcase
      end
    end
  end
end
