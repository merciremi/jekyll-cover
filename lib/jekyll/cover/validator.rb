# frozen_string_literal: true

module Jekyll
  module Cover
    # Documented by Remi - 9 Jul 2024
    #
    # This class is responsible for:
    #   - checking the presence of the path
    #   - or raising a custom error if the path is missing
    #
    # As of Jul 2024, this class is a tad too composable, but I know I'll want to
    # add more options in the command at some point, so I'm preparing for that.
    class Validator
      attr_reader :flag, :object

      def initialize(flag, object)
        @flag = flag
        @object = object
      end

      def present?
        raise ValidationError, "Please provide a #{flag} with the #{flag} option." if object.nil?

        true
      end
    end
  end
end
