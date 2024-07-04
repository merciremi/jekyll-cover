# frozen_string_literal: true

module Jekyll
  module Cover
    class Website
      def initialize
        build
      end

      def build
        @built ||= false

        Jekyll::Commands::Build.process({}) && @built = true

        site
      end

      def site
        build unless @built

        @site ||= Jekyll.sites.first
      end

      # def posts
      #   @posts ||= site.posts.docs
      # end
    end
  end
end
