# frozen_string_literal: true

require_relative 'cover/version'
require_relative 'cover/path_validator'
require_relative 'cover/website'
require_relative 'cover/matches'
require_relative 'cover/folder_handler'
require_relative 'cover/cover_image'

module Jekyll
  module Cover
    class Error < StandardError; end
    # Your code goes here...
  end
end

require 'jekyll/commands/cover'
