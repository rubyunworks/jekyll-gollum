module Jekyll
  module Gollum

    # Gollum Post is just like a Jekyll Post except that
    # metadata is not in the form of YAML front-matter.
    #
    class Post < Jekyll::Post
      #alias read_yaml_front_matter read_yaml 

      # Read the YAML frontmatter.
      #
      # base - The String path to the dir containing the file.
      # name - The String filename of the file.
      #
      # Returns nothing.
      def read_yaml(base, name)
        begin
          text = File.read(File.join(base, name))
          data = {'layout'=>'post'}

          conf = site.config['gollum'] || {}

          if yaml = conf['post_yaml']
            data.merge!(data)
          end

          if text =~ /<!---*\ +---\s+(.*?)\s+-*-->\s*$\n?/m
            text.delete($0)
            data.merge!(YAML.safe_load($1))
          end

          self.content = text
          self.data = data
        rescue SyntaxError => e
          puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
        rescue Exception => e
          puts "Error reading file #{File.join(base, name)}: #{e.message}"
        end

        unless self.data['layout']
          self.data['layout'] = 'post'
        end

        # Why did jekyll put this here. It doesn't even seem to work as it should.
        self.extracted_excerpt = self.extract_excerpt
      end

      #
      def path
        self.data['path'] || File.join(@dir, @name).sub(/\A\//, '')
      end

      #
      def containing_dir(source, dir)
        return File.join(source, dir)
      end
    end

  end
end
