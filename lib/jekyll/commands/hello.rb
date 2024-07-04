# frozen_string_literal: true
require 'jekyll'

module Jekyll
  module Commands
    class Hello < Command
      class << self
        def init_with_program(prog)
          prog.command(:hello) do |c|
            c.syntax 'build_cover_image [options]'
            c.description 'This command takes a post path as arg and build a cover image'
            c.option 'path', '-p PATH', '--path PATH', 'The path of the post'

            c.action do |_args, options|
              path = Jekyll::Hello::PathValidator.new(options['path']).check_presence

              site = Jekyll::Hello::Website.new.site

              post_file = File.read(path)

              matches = Jekyll::Hello::Matches.new(post_file)

              folder_handler = Jekyll::Hello::FolderHandler.new(site, matches).find_or_initialize_folder

              image = Jekyll::Hello::CoverImage.new(folder_handler, matches, post_file, path).create
              image.add_slug_to_file!
            end
          end
        end
      end
    end
  end
end
