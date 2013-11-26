module Jekyll
  module Gollum

    # Gollum Generator for Jekyll. This is the heart of the plugin.
    #
    class Generator < Jekyll::Generator
      safe true

      # These are the formats Jekyll supports.
      EXTNAMES = %w{.md .markdown .tt .textile}

      # Generte site.
      #
      # TODO: Handle drafts.
      #
      # Returns nothing.
      def generate(site)
        return unless site.config.key?('gollum')

        folder = site.config['gollum']['folder'] || '_wiki'

        source = File.join(site.source, folder)
        files  = glob_entries(source)

        files.each do |file|
          real_path = File.join(source, file)

          next if File.directory?(real_path)

          if is_post?(real_path)
            post = Gollum::Post.new(site, source, File.dirname(file), File.basename(file))
            site.posts << post
          elsif is_page?(real_path)
            page = Gollum::Page.new(site, source, File.dirname(file), File.basename(file))
            site.pages << page
          else
            static = StaticFile.new(site, source, File.dirname(file), File.basename(file))
            site.static_files << static
          end
        end
      end

      # Get a list of all files in given dir.
      #
      # Returns list of paths.
      def glob_entries(dir)
        Dir.glob(File.join(dir, '**/*')).map do |d|
          d.sub(dir+'/', '')
        end
      end

      # Is the file a post?
      #
      # Returns true or false. [Boolean]
      def is_post?(file)
        /\d\d\d\d-\d\d-\d\d/ =~ File.basename(file)
      end

      # Is the file a page?
      #
      # Returns true or false. [Boolean]
      def is_page?(file)
        EXTNAMES.include?(File.extname(file))
      end
    end

  end
end
