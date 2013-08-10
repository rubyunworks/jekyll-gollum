module Jekyll

  class TransformPage < Page
    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      begin
        self.content = File.read(File.join(base, name))

        config_data = (site.config['transform'] || {})['page_yaml'] || {} #{'layout'=>'default'}
        if self.content =~ /(<!---\s+---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = config_data.merge(YAML.safe_load($1))
        else
          self.data = config_data
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{File.join(base, name)}: #{e.message}"
      end

      self.data ||= {'layout'=>'page'}
    end
  end

  class TransformPost < Post
    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      begin
        self.content = File.read(File.join(base, name))

        config_data = (site.config['transform'] || {})['post_yaml'] || {} #{'layout'=>'default'}
        if self.content =~ /(<!---\s+---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = config_data.merge(YAML.safe_load($1))
        else
          self.data = config_data
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{File.join(base, name)}: #{e.message}"
      end

      self.data ||= {'layout'=>'post'}

      self.extracted_excerpt = self.extract_excerpt
    end

    def path
      self.data['path'] || File.join(@dir, @name).sub(/\A\//, '')
    end

    def containing_dir(source, dir)
      return File.join(source, dir)
    end
  end


  class TransformGenerator < Generator
    safe true

    #
    # TODO: Handle drafts.
    #
    def generate(site)
      return unless site.config.key?('transform')

      folder = site.config['transform']['folder'] || '_trans'
      source = File.join(site.source, folder)
      files = transform_entries(source)
      files.each do |file|
        if is_post?(File.join(source, file))
          post = TransformPost.new(site, source, File.dirname(file), File.basename(file))
          site.posts << post
        else
          page = TransformPage.new(site, source, File.dirname(file), File.basename(file))
          site.pages << page
        end
      end
    end

    def transform_entries(dir)
      Dir.glob(File.join(dir, '**/*')).map do |d|
        d.sub(dir+'/', '')
      end
    end

    def is_post?(file)
      /\d\d\d\d-\d\d-\d\d/ =~ File.basename(file)
    end

  end

end
