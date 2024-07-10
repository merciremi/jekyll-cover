# frozen_string_literal: true

require 'rmagick'

module Jekyll
  module Cover
    # Documented by Remi - 10 Jul 2024
    #
    # This class is the procedure responsible for:
    #   - building the cover image: background, title, excerpt, author information
    #   - outputting the image to the appropriate folder
    #
    # I've kept this class very procedural - in the spirit of service objects.
    # Yet, it also returns a set of attributes that can be called upon if need be.
    class CoverImage
      CATEGORIES_DECORS = {
        rails: 'golden-mountain.png',
        ruby: 'pinkish-sun.png',
        rspec: 'brown-rock.png',
        career: 'stormy-river.png'
      }.freeze

      attr_reader :website, :post, :title, :excerpt

      def initialize(website, post)
        @website = website
        @post = post

        @title = OpenStruct.new(lower_position: 0.0)
        @excerpt = OpenStruct.new(lower_position: 0.0)
      end

      def create
        add_background!
        add_title!
        add_excerpt!
        add_author_information!
        output_image!

        self
      end

      def relative_path
        @relative_path ||= "/media/#{post.year}/#{post.month}/#{formatted_slug}.png"
      end

      private

      def image
        @image ||= Magick::Image.new(1012, 506) do |options|
          options.background_color = 'hsl(38, 44%, 96%)'
        end
      end

      def image_text
        @image_text ||= Magick::Draw.new
      end

      def add_title!
        # Could I transform these config value as a block or something to pass to Magick::Draw?
        image_text.font = 'SF-Pro-Display-Black'
        image_text.font_weight = 900
        image_text.pointsize = 64
        image_text.gravity = Magick::NorthWestGravity

        wrapped_title = wrap_text(post.title, image_text, 900)

        image_text.annotate(image, 75, 75, 75, 75, wrapped_title) do |options|
          options.fill = 'hsl(202, 77%, 7%)'
        end

        metrics = image_text.get_type_metrics(wrapped_title)

        @title.lower_position = metrics.height + metrics.bounds.x2 + metrics.ascent
      end

      def add_excerpt!
        image_text.font = 'SF-Pro-Display'
        image_text.font_weight = 700
        image_text.pointsize = 20
        image_text.gravity = Magick::NorthWestGravity

        wrapped_excerpt = wrap_text(post.excerpt, image_text, 700)

        image_text.annotate(image, 75, 75, 75, title.lower_position + 75, wrapped_excerpt) do |options|
          options.fill = 'hsl(0, 0%, 26%)'
        end

        metrics = image_text.get_type_metrics(wrapped_excerpt)

        @excerpt.lower_position = metrics.height + metrics.bounds.x2 + metrics.ascent
      end

      def add_author_information!
        # Add avatar
        face_image = Magick::Image.read(website.source + post.avatar).first
        face_image = face_image.resize_to_fit(50, 50)

        # 435 is the position from the top: could be computed from the canvas size instead
        image.composite!(face_image, 75, 435, Magick::OverCompositeOp)

        # Add author information inlined with avatar
        image_text.font = 'SF-Pro-Display-Black'
        image_text.font_weight = 700
        image_text.pointsize = 20
        image_text.gravity = Magick::NorthWestGravity

        information = "#{post.website} - #{post.mastodon}"

        # 450 is the position from the top: could be computed from the canvas size instead
        image_text.annotate(image, 75, 75, 150, 450, information) do |options|
          options.fill = 'hsl(202, 77%, 7%)'
        end
      end

      def add_background!
        decor = CATEGORIES_DECORS[post.category.to_sym]

        decor_image = Magick::Image.read(website.source + "/media/shared/#{decor}").first
        decor_image = decor_image.resize_to_fit(400, 400)

        x_offset = image.columns - decor_image.columns + 50
        y_offset = image.rows - decor_image.rows + 50

        image.composite!(decor_image, x_offset, y_offset, Magick::OverCompositeOp)
      end

      def output_image!
        folder = website.find_or_initialize_folder("#{post.year}/#{post.month}")

        image.write("#{folder.path}/#{formatted_slug}.png")
      end

      def formatted_slug
        "remi-mercier-#{post.title.gsub(/(\s|'|\p{P})/, '-').gsub('--', '-').downcase}"
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
