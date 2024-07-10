# frozen_string_literal: true

module Jekyll
  module Cover
    # Documented by Remi - 9 Jul 2024
    #
    # This class is a procedural wrapper responsible for:
    #   - rebuilding the Jekyll website
    #   - and accessing some Jekyll variables
    #
    # As of Jul 2024, I only expose the bare minimum of those variables. Hence why
    # I return the Jekyll site variable in the .`build` class method.
    # This might change in the future if I need to be more composable.
    #
    # @see https://jekyllrb.com/docs/variables/
    class Website
      class << self
        def build
          new
        end
      end

      def initialize
        @built = false

        build
      end

      def site
        @site ||= Jekyll.sites.first
      end

      def source
        @source ||= site.source
      end

      def find_or_initialize_folder(path)
        full_path = File.join(source, 'media', path)

        Dir.mkdir(full_path) unless Dir.exist?(full_path)

        Dir.open(full_path)
      end

      private

      def build
        return if @built

        Jekyll::Commands::Build.process({}) && @built = true
      end
    end
  end
end
