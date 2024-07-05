# frozen_string_literal: true

module Jekyll
  module Cover
    class Matches
      PATTERNS = [
        /^(title:\s?)(.*)$/,
        /^(date:\s?)(.*)$/,
        /^(category:\s?)(.*)$/,
        /^(excerpt:\s?)(.*)$/
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

        @matches['avatar'] = '/media/shared/remi-mercier-2024.png'
        @matches['mastodon'] = '@remi@ruby.social '
        @matches['website'] = 'remimercier.com'

        @matches
      end

      def title
        # Will remove opening and closing quotes, but not those in the title
        @title ||= @matches.title.gsub!(/^"|^'|"\Z|'\Z/, '')
      end

      def excerpt
        # Will remove opening and closing quotes, but not those in the excerpt
        @excerpt ||= @matches.excerpt.gsub!(/^"|^'|"\Z|'\Z/, '')
      end

      def website
        @website ||= @matches.website
      end

      def mastodon
        @mastodon ||= @matches.mastodon
      end

      def avatar
        @avatar ||= @matches.avatar
      end

      def category
        @category ||= @matches.category
      end

      def date
        # Will handle date of these formats: 2024-06-01 and 01/06/2024
        @date ||= Time.parse(matches.date).strftime('%Y-%m-%d')
      end

      def year
        @year ||= matches.date.split('-')[0]
      end

      def month
        @month ||= matches.date.split('-')[1]
      end
    end
  end
end
