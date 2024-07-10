# frozen_string_literal: true

require_relative 'cover/version'
require_relative 'cover/validator'
require_relative 'cover/website'
require_relative 'cover/front_matter'
require_relative 'cover/cover_image'
require_relative 'cover/post'

require 'pry-byebug'

module Jekyll
  module Cover
    class Error < StandardError; end
    class ValidationError < Error; end
    class FileDoesNotExistError < Error; end
    class CoverImageAlreadySetError < Error; end
  end
end

require 'jekyll/commands/cover'
