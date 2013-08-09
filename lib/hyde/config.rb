module Hyde

  class Config

    def self.load(path)
      if File.directory?(path)
        file = File.join(path, '_config.yml')
      else
        file = path
      end
      new(YAML.load_file(file))
    end

    #
    def initialize(data)
      @data = data
    end

    #
    def method_missing(n, *a, &b)
      super(n, *a, &b) unless a.empty?
      super(n, *a, &b) if b

      @data[n]
    end

  end

end
