# frozen_string_literal: true

module Jekyll
  module Cover
    # Documented by Remi - 10 Jul 2024
    #
    # This class is responsible for:
    #   - checking the existence of the file
    #   - extracting and exposing the front matter from the file
    #   - exposing values related to the post such as title, excerpt, etc...
    #   - handling the insertion of the cover image path to the post's front matter
    class Post
      attr_reader :path

      def initialize(path)
        @path = path

        @file ||= file
        @front_matter ||= front_matter
      end

      def file
        raise FileDoesNotExistError, "Can not open file with path: #{path}" unless File.exist?(path)

        File.read(path)
      end

      def front_matter
        Jekyll::Cover::FrontMatter.new(file).extract_variables
      end

      # Thought: All these front_matter.variables.something could use a little delegation.
      def title
        @title ||= front_matter.variables.title.gsub!(/^"|^'|"\Z|'\Z/, '')
      end

      def excerpt
        @excerpt ||= front_matter.variables.excerpt.gsub!(/^"|^'|"\Z|'\Z/, '')
      end

      def date
        # Will handle date of these formats: 2024-06-01 and 01/06/2024
        @date ||= Time.parse(front_matter.variables.date).strftime('%Y-%m-%d')
      end

      def year
        @year ||= front_matter.variables.date.split('-')[0]
      end

      def month
        @month ||= front_matter.variables.date.split('-')[1]
      end

      def avatar
        @avatar ||= front_matter.variables.avatar
      end

      def category
        @category ||= if front_matter.variables.category.instance_of?(String)
                        front_matter.variables.category
                      else
                        front_matter.variables.category.first
                      end
      end

      def mastodon
        @mastodon ||= front_matter.variables.mastodon
      end

      def website
        @website ||= front_matter.variables.website
      end

      def add_cover_image_path_to_front_matter(cover_image_path)
        scanned_file = StringScanner.new(file)
        scanned_file.scan_until(/cover_image:/)

        unless scanned_file.peek(4).strip == '---'
          raise CoverImageAlreadySetError, 'A cover image is already set for this post'
        end

        new_content = file.insert(scanned_file.pos, " '#{cover_image_path}'")

        File.open(path, 'w') { |file| file.write(new_content) }
      end
    end
  end
end
