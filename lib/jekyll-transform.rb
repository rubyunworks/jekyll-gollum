module Jekyll

  class TransformPage < Page
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
        data = (site.config['transform'] || {})['page_yaml'] || {'layout'=>'default'}

        if text =~ /<!--\s+---\s*\n(.*?)^-->\s*$\n?/m
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

  class TransformPost < Post
    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      begin
        text = File.read(File.join(base, name))
        data = (site.config['transform'] || {})['post_yaml'] || {'layout'=>'post'}

        if text =~ /<!--\s+---\s*\n(.*?)^-->\s*$\n?/m
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
        real_path = File.join(source, file)
        next if File.directory?(real_path)
        if is_post?(real_path)
          post = TransformPost.new(site, source, File.dirname(file), File.basename(file))
          site.posts << post
        elsif is_page?(real_path)
          page = TransformPage.new(site, source, File.dirname(file), File.basename(file))
          site.pages << page
        else
          static = StaticFile.new(site, source, File.dirname(file), File.basename(file))
          site.static_files << static
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

    def is_page?(file)
      EXTNAMES.include?(File.extname(file))
    end

    EXTNAMES = %w{.md .markdown .tt .textile}
  end

end
