module Hyde

  # Smeagol::CLI module is a function module that provide
  # all command line interfaces.
  #
  module CLI

    extend self

    #
    # Initialize wiki site for use with Hyde.
    #
    def init(argv)
      parser.banner = "usage: hyde init [OPTIONS] [WIKI-URI]\n"

      parser.on('-i', '--index [PAGE]') do |page_name|
        options[:index] = page_name
      end

      Console.init(*parse(argv))
    end

    #
    # Serve development preview of site.
    #
    def serve(argv)
      parser.banner = "Usage: hyde serve [OPTIONS]\n"

      #parser.on('--port [PORT]', 'Bind port (default 4567).') do |port|
      #  options[:port] = port.to_i
      #end

      #parser.on('--[no-]cache', 'Enables page caching.') do |flag|
      #  options[:cache] = flag
      #end

      #parser.on('--mount-path', 'Serve website from this base path.') do |path|
      #  options[:mount_path] = path
      #end

      ##parser.on('--auto-update', 'Updates the repository on a daily basis.') do |flag|
      ##  options[:auto_update] = flag
      ##end

      ##parser.on('--secret [KEY]', 'Specifies the secret key used to update.') do |str|
      ##  options[:secret] = str
      ##end

      #$stderr.puts "Starting preview..."

      Console.preview(*parse(argv))
    end

    #
    # Update wiki repository.
    #
    def update(argv)
      parser.banner = "Usage: hyde update [OPTIONS]\n"

      #parser.on('-s', '--site', 'Also update site directories, if applicable.') do
      #  options[:site] = true
      #end

      Console.update(*parse(argv))
    end

  private

    #
    # Command line options.
    #
    # Returns the command line options. [Hash]
    #
    def options
      @options ||= {}
    end

    #
    # Read command line options into `options` hash.
    #
    # Returns arguments and options. [Array]
    #
    def parse(argv)
      begin
        parser.parse!(argv)
      rescue ::OptionParser::InvalidOption
        puts "hyde: #{$!.message}"
        puts "hyde: try 'hyde --help' for more information"
        exit 1
      end
      return *(argv + [options])
    end

    #
    # Create and cache option parser.
    #
    # Returns option parser instance. [OptionParser]
    #
    def parser
      @parser ||= (
        parser = ::OptionParser.new
        parser.on_tail('--quiet', 'Turn on $QUIET mode.') do
          $QUIET = true
        end
        parser.on_tail('--debug', 'Turn on $DEBUG mode.') do
          $DEBUG = true
        end
        parser.on_tail('-v', '--version', 'Display current version.') do
          puts "Hyde #{Hyde::VERSION}"
          exit 0
        end
        parser.on_tail('-h', '-?', '--help', 'Display this help screen.') do
          puts parser
          exit 0
        end
        parser
      )
    end

  end

end
