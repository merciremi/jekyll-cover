# frozen_string_literal: true

module Jekyll
  module Hello
    class FolderHandler
      attr_reader :site, :matches

      def initialize(site, matches)
        @site = site
        @matches = matches
      end

      def find_or_initialize_folder
        Dir.mkdir(year_path) unless Dir.exist?(year_path)

        Dir.mkdir(month_path) unless Dir.exist?(month_path)

        self
      end

      def year_path
        @year_path ||= File.join(site.source, 'media', matches.year.to_s)
      end

      def month_path
        @month_path ||= File.join(site.source, 'media', matches.year.to_s, matches.month.to_s)
      end
    end
  end
end
