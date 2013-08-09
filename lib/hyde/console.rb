module Hyde

  # Console encapsulates all the public methods
  # smeagol is likely to need, generally it maps
  # to all the CLI commands.
  #
  module Console
    extend self

    #
    # Initialize a git-based wiki for use with Hyde. This will clone the wiki
    # repo to `_wiki` and add it to .gitignore.
    #
    # Returns nothing.
    #
    def init(*args)
      options = (Hash === args.last ? args.pop : {})

      abort "Too many arguments." if args.size > 1

      @wiki_url = args.shift
      @root_dir = options['root'] || Dir.pwd

      if File.exist?(wiki_dir)
        raise "hyde: _wiki directory already exists."
      end

      clone_wiki
      save_gitignore
      #save_config
    end

    #
    # Update wiki repo(s).
    #
    def update(*args)
      options = (Hash === args.last ? args.pop : {})

      if wiki_dir
        system "cd #{wiki_dir}; #{git} pull origin #{branch}"
        #dir  = File.expand_path(wiki_dir)
        #repo = Repository.new(:path=>dir)
        #out  = repo.update
        #out  = out[1] if Array === out
        #report out
      else
        raise "hyde: no _wiki directory exists."
      end
    end

    #
    # Serve a preview of site.
    #
    # This routine simply routes through jykell command line interface.
    #
    def serve(argv)
      system "jykell serve #{argv.join(' ')}"
    end

    #
    #
    #
    def transform(*args)
      options = (Hash === args.last ? args.pop : {})

      @root_dir = options['root'] || Dir.pwd
      @wiki_dir = File.join(@root_dir, '_wiki')

      transformer = Transformer.new(:root=>@root_dir) #, :wiki=>@wiki_dir)
      transformer.transform
    end

    #
    # Jykell site directory.
    #
    def root_dir
      @root_dir ||= Dir.pwd
    end

    #
    # Wiki's git origin url.
    #
    # If unassigned it will get the wiki's origin url from the git config.
    #
    def wiki_url
      @wiki_url ||= (
        url  = nil
        file = File.join(@wiki_dir, '.git', 'config')
        mark = false

        if File.file?(file)
          File.readlines(file).each do |line|
            if mark
              if md = /url\s+\=/.match(line.strip)
                return md.post_match.strip
              end
            else
              mark = true if '[remote "origin"]' == line.rstrip
            end
          end
        end

        url
      )
    end

    #
    # Set wiki git url.
    #
    def wiki_url=(url)
      @url = url
    end

    #
    # Directory that contains wiki repo.
    #
    def wiki_dir
      @wiki_dir ||= File.join(root_dir, '_wiki')
    end

    #
    # Clone the wiki.
    #
    def clone_wiki
      system "git clone #{wiki_url} #{wiki_dir}"
    end

    #
    # Create or append `_wiki` to .gitignore file.
    #
    def save_gitignore(directory)
      file = File.join(directory, '.gitignore')
      if File.exist?(file)
        text = File.read(file)
        if text !~ /$wiki\//
          File.open(file, 'a') do |f|
            f.write("_wiki/")
          end
        end
      else
        File.open(file, 'w') do |f|
          f.write("_wiki/")
        end
      end
    end

    # DEPRECATED
    def save_config(directory)
      file = File.join(directory, '_config.yml')
      if File.exist?(file)
        text = File.read(file)
        if text !~ /$wiki:/
          File.open(file, 'a') do |f|
            f.write("wiki:")
            f.write("  origin: #{wiki_url}")
            f.write("  branch: master")
          end
        end
      else
        File.open(file, 'w') do |f|
          f.write("_wiki/")
        end
      end
    end

=begin
    #
    # Preview current site (from working directory).
    #
    def serve(options)
      repository = {}
      repository[:path]   = Dir.pwd
      #repository[:cname] = options[:cname]  if options[:cname]
      repository[:secret] = options.delete(:secret) if options.key?(:secret)

      options[:repositories] = [repository]

      config = Smeagol::Config.new(options)

      catch_signals
      show_repository(config)

      run_server(config)
    end
=end

    #
    # Get and cache Wiki object.
    #
    # Returns wiki. [Wiki]
    #
    def wiki
      @wiki ||= Hyde::Wiki.new(wiki_dir)
    end

    #
    # Jykell configuration settings.
    #
    # Returns Jykell configuration settings. [Config]
    #
    def config
      @config ||= Config.load(root_dir)
    end

    #
    # Locate the git binary in common places in the file system.
    #
    # TODO: Can we use shell.rb for this?
    #
    # TODO: This hsould not be necessary. 99% of the time it's just `git`.
    #       For the rest if $GIT environment variable.
    #
    # Returns String path to git executable.
    #
    def git
      ENV['git'] || ENV['GIT'] || 'git'
    end

    #
    # Output a message to $stderr unless $QUIET is true.
    #
    # Returns nothing.
    #
    def report(msg)
      $stderr.puts msg unless $QUIET
    end

    # DEPRECATED
    def copy_dir(src_dir, dst_dir)
      FileUtils.mkdir_p(dst_dir)

      Dir[File.join(src_dir, '**/*')].each do |src|
        next if File.directory?(src)
        dst = File.join(dst_dir, src.sub(src_dir, ''))
        copy_file(src, dst)
      end
    end

    # DEPRECATED
    def copy_file(src, dst)
      if File.exist?(dst)
        report " skip: #{dst.sub(Dir.pwd,'')}"
      else
        FileUtils.mkdir_p(File.dirname(dst))
        FileUtils.cp(src, dst)
        report " copy: #{dst.sub(Dir.pwd,'')}"
      end
    end

#    #
#    # Setup trap signals.
#    #
#    def catch_signals
#      Signal.trap('TERM') do
#        Process.kill('KILL', 0)
#      end
#    end


=begin
    #
    # Copy layout templates to `_layouts` directory and 
    # partial templates to `_partials`.
    #
    def copy_layouts
      dst_dir = File.join(wiki_dir, '_layouts')
      src_dir = LIBDIR + '/templates/layouts'
      copy_dir(src_dir, dst_dir)

      dst_dir = File.join(wiki_dir, '_partials')
      src_dir = LIBDIR + '/templates/partials'
      copy_dir(src_dir, dst_dir)
    end

    #
    # Copy assets to `assets` directory. 
    #
    def copy_assets
      dst_dir = File.join(wiki_dir, 'assets')
      src_dir = LIBDIR + '/public/assets'
      copy_dir(src_dir, dst_dir)
    end
=end

  end

end
