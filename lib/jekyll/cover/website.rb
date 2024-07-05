# frozen_string_literal: true

module Jekyll
  module Cover
    class Website
      def initialize
        build
      end

      def site
        build unless @built

        @site = Jekyll.sites.first
      end

      private

      def build
        @built = false

        Jekyll::Commands::Build.process({}) && @built = true
      end
    end
  end
end
