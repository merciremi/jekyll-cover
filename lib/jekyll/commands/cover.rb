# frozen_string_literal: true

require 'jekyll'

module Jekyll
  module Commands
    class Cover < Command
      class << self
        # Documented by Remi - 10 Jul 2024
        #
        # This class is the main orchestrator responsible for:
        # - checking the validity of the user input
        # - exposing the necessary values from the post
        # - exposing the necessary values from the website
        # - building and exposing the cover image
        #
        # Thoughts: May be, the easiest way to make this gem usable for other people
        # would be to have a CLI Q&A-thingy. People could setup their own variables.
        # Example: "What is the path of your avatar?" "What is the url of your social media?"
        def init_with_program(prog)
          prog.command(:cover) do |c|
            c.syntax 'build_cover_image [options]'
            c.description 'This command takes a post path as arg and build a cover image'
            c.option 'path', '-p PATH', '--path PATH', 'The path of the post'

            c.action do |_args, options|
              path = options['path'] if Jekyll::Cover::Validator.new('path', options['path']).present?

              post = Jekyll::Cover::Post.new(path)

              website = Jekyll::Cover::Website.build

              image = Jekyll::Cover::CoverImage.new(website, post).create

              post.add_cover_image_path_to_front_matter(image.relative_path)
            end
          end
        end
      end
    end
  end
end
