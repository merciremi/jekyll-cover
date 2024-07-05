# frozen_string_literal: true

require 'jekyll'

module Jekyll
  module Commands
    class Cover < Command
      class << self
        def init_with_program(prog)
          prog.command(:cover) do |c|
            c.syntax 'build_cover_image [options]'
            c.description 'This command takes a post path as arg and build a cover image'
            c.option 'path', '-p PATH', '--path PATH', 'The path of the post'

            c.action do |_args, options|
              path = Jekyll::Cover::PathValidator.new(options['path']).check_presence

              site = Jekyll::Cover::Website.new.site

              file = File.read(path)

              matches = Jekyll::Cover::Matches.new(file)

              folder_handler = Jekyll::Cover::FolderHandler.new(site, matches).find_or_initialize_folder

              image = Jekyll::Cover::CoverImage.new(folder_handler, matches, file, path).create
              image.add_slug_to_file!
            end
          end
        end
      end
    end
  end
end
