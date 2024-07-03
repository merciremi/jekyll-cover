# frozen_string_literal: true

module Jekyll
  module Hello
    class Matches
      PATTERNS = [
        /^(title:\s?)(.*)$/,
        /^(date:\s?)(.*)$/,
        /^(category:\s?)(.*)$/
      ].freeze

      attr_reader :file, :matches

      def initialize(file)
        @file = file

        extract_matches
      end

      def extract_matches
        @matches ||= OpenStruct.new

        PATTERNS.each do |pattern|
          match = pattern.match(file)

          @matches[match[1].gsub!(': ', '')] = match[2]
        end

        @matches['avatar'] = '/media/remi-mercier-old.jpeg'
        @matches['mastodon'] = '@remi@ruby.social '
        @matches['website'] = 'https://remimercier.com/'

        @matches
      end

      def title
        # Will remove opening and closing quotes, but not those in the title
        @title ||= @matches.title.gsub!(/^"|^'|"\Z|'\Z/, '')
      end

      def date
        @date ||= matches.date
      end

      def year
        matches.date.split('-')[0]
      end

      def month
        matches.date.split('-')[1]
      end
    end
  end
end
