# frozen_string_literal: true

module Jekyll
  module Cover
    # Documented by Remi - 9 Jul 2024
    #
    # This class is responsible for:
    #   - extracting the values stored in the post's front matter
    #   - exposing nicely formatted values for other parts of the gem.
    #
    # I'm trying a syntaxic experiment here where I only formalize an attribute as attr_reader
    # if it's accessible through the public API. If not, it keeps its @ in front of it.
    # I can already tell it's not very consistent, since all my @variables declare new public
    # attributes with an @. Anyways, will keep digging.
    class FrontMatter
      # These default variables should live in ::Website, since they are extracted from
      # the website configuration.
      DEFAULT_VARIABLES = {
        avatar: '/media/shared/remi-mercier-2024.png',
        mastodon: '@remi@ruby.social',
        website: 'remimercier.com' # Can be accessed through site.config['url'] but I need to pass the site to this class
      }.freeze

      PATTERNS = [
        /^(title:\s?)(.*)$/,
        /^(date:\s?)(.*)$/,
        /^(category:\s?)(.*)$/,
        /^(excerpt:\s?)(.*)$/
      ].freeze

      attr_reader :variables

      def initialize(file)
        @file = file

        @variables ||= OpenStruct.new(DEFAULT_VARIABLES)
      end

      def extract_variables
        PATTERNS.each do |pattern|
          match = pattern.match(@file)

          @variables[match[1].gsub!(': ', '').to_sym] = match[2]
        end

        self
      end
    end
  end
end
