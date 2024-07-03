# frozen_string_literal: true

require_relative "hello/version"
require_relative "hello/path_validator"
require_relative "hello/website"
require_relative "hello/matches"
require_relative "hello/folder_handler"
require_relative "hello/cover_image"

module Jekyll
  module Hello
    class Error < StandardError; end
    # Your code goes here...
  end
end

require "jekyll/commands/hello.rb"
