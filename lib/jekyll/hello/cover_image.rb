# frozen_string_literal: true

module Jekyll
  module Hello
    class CoverImage
      attr_reader :folder_handler, :matches, :file, :path

      def initialize(folder_handler, matches, file, path)
        @folder_handler = folder_handler
        @matches = matches
        @file = file
        @path = path
      end

      def create
        annotate

        image.write(full_path)

        self
      end

      def annotate
        image_text.font_family = 'helvetica'
        image_text.pointsize = 52
        image_text.gravity = Magick::CenterGravity

        image_text.annotate(image, 0, 0, 2, 2, matches.title) do |options|
          options.fill = 'black'
        end
      end

      def add_slug_to_file!
        cover_image_position = file.index('cover_image:')

        new_content = file.insert(cover_image_position + 'cover_image:'.length, " \"/media/#{matches.year}/#{matches.month}/#{formatted_slug}.png\"")

        # Improvement: how do I access the path, when I only have the result of File.read?
        # new param or is there a cleaner version?
        File.open(path, 'w') { |file| file.write(new_content) }
      end

      private

      def image
        @image ||= Magick::Image.new(1012, 506) do |options|
          options.background_color = 'white'
        end
      end

      def image_text
        @image_text ||= Magick::Draw.new
      end

      def formatted_slug
        "remi-mercier-#{matches.title.gsub('"', '').gsub(/(\s|'|\p{P})/, '-').downcase}"
      end

      def full_path
        "#{folder_handler.month_path}/#{formatted_slug}.png"
      end
    end
  end
end
