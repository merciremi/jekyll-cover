# frozen_string_literal: true

module Jekyll
  module Hello
    class PathValidator
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def check_presence
        if path.nil?
          puts "Please provide the path to the post file with -p option."

          exit
        else
          path
        end
      end
    end
  end
end
