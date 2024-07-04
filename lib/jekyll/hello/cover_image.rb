# frozen_string_literal: true

require 'rmagick'
require 'pry'

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
        add_background

        title = annotate_title
        excerpt = annotate_excerpt(title.lower_position)
        annotate_information(title.lower_position, excerpt.lower_position)

        image.write(full_path)

        self
      end

      def annotate_title
        image_text.font = 'SF-Pro-Display-Black'
        image_text.font_weight = 900
        image_text.pointsize = 64
        image_text.gravity = Magick::NorthWestGravity

        wrapped_title = wrap_text(matches.title, image_text, 900)

        image_text.annotate(image, 75, 75, 75, 75, wrapped_title) do |options|
          options.fill = 'hsl(202, 77%, 7%)'
        end

        metrics = image_text.get_type_metrics(wrapped_title)

        # binding.pry

        OpenStruct.new(lower_position: metrics.height + metrics.bounds.x2 + metrics.ascent)
      end

      def annotate_excerpt(title_lower_position)
        image_text.font = 'SF-Pro-Display'
        image_text.font_weight = 700
        image_text.pointsize = 20
        image_text.gravity = Magick::NorthWestGravity

        wrapped_excerpt = wrap_text(matches.excerpt, image_text, 700)

        image_text.annotate(image, 75, 75, 75, title_lower_position + 75, wrapped_excerpt) do |options|
          options.fill = 'hsl(0, 0%, 26%)'
        end

        metrics = image_text.get_type_metrics(wrapped_excerpt)

        OpenStruct.new(lower_position: metrics.height + metrics.bounds.x2 + metrics.ascent)
      end

      def annotate_information(title_lower_position, excerpt_lower_position)
        face_image = Magick::Image.read(folder_handler.site.source + matches.avatar).first

        face_image = face_image.resize_to_fit(50, 50)

        image.composite!(face_image, 75, 435, Magick::OverCompositeOp)

        image_text.font = 'SF-Pro-Display-Black'
        image_text.font_weight = 700
        image_text.pointsize = 20
        image_text.gravity = Magick::NorthWestGravity

        information = "#{matches.website} - #{matches.mastodon}"

        image_text.annotate(image, 75, 75, 150, 450, information) do |options|
          options.fill = 'hsl(202, 77%, 7%)'
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
          options.background_color = 'hsl(38, 44%, 96%)'
        end
      end

      def add_background
        decors = {
          rails: 'golden-mountain.png',
          ruby: 'pinkish-sun.png',
          rspec: 'brown-rock.png',
          career: 'stormy-river.png'
        }

        category = matches.category.instance_of?(String) ? matches.category : matches.category.first

        decor = decors[category.to_sym]

        decor_image = Magick::Image.read(folder_handler.site.source + "/media/shared/#{decor}").first

        decor_image = decor_image.resize_to_fit(400, 400)

        x_offset = image.columns - decor_image.columns + 50
        y_offset = image.rows - decor_image.rows + 50

        image.composite!(decor_image, x_offset, y_offset, Magick::OverCompositeOp)
      end

      def image_text
        @image_text ||= Magick::Draw.new
      end

      def formatted_slug
        "remi-mercier-#{matches.title.gsub(/(\s|'|\p{P})/, '-').gsub('--', '-').downcase}"
      end

      def full_path
        "#{folder_handler.month_path}/#{formatted_slug}.png"
      end

      def wrap_text(text, draw, max_width)
        if text.include?(':')
          first_line, second_line = text.split(':')
          first_line = wrap_text(first_line, draw, max_width)
          second_line = wrap_text(second_line, draw, max_width)

          "#{first_line}:\n#{second_line}"
        else
          wrapped_text = ''
          line = ''

          text.split.each do |word|
            test_line = line.empty? ? word : "#{line} #{word}"
            metrics = draw.get_type_metrics(test_line)

            if metrics.width <= max_width
              line = test_line
            else
              wrapped_text += (wrapped_text.empty? ? line : "\n#{line}")
              line = word
            end
          end

          wrapped_text += (wrapped_text.empty? ? line : "\n#{line}") unless line.empty?
          wrapped_text
        end
      end
    end
  end
end
