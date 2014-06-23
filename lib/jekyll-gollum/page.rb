module Jekyll
  module Gollum

    # Gollum Page is just like a Jekyll Page except that
    # metadata is not in the form of YAML front-matter.
    #
    class Page < Jekyll::Page
      #alias read_yaml_front_matter read_yaml 

      # Read the YAML metadata.
      #
      # base - The String path to the dir containing the file.
      # name - The String filename of the file.
      #
      # Returns nothing.
      def read_yaml(base, name)
        begin
          text = File.read(File.join(base, name))
          data = {'layout'=>'default'}

          conf = site.config['gollum'] || {}

          if yaml = conf['page_yaml']
            data.merge!(yaml)
          end

          if text =~ /<!--\s+---\s+(.*?)\s+-->\s*$\n?/m
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
          self.data['layout'] = 'page'
        end

        return self.data
      end
    end

  end
end
