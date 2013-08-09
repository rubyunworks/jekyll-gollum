module Hyde

  class Transformer

    #
    def initialize(options={})
      @root_directory = options[:root]
      @wiki_directory = options[:wiki]
    end

    #
    def root_directory
      @root_directory ||= Dir.pwd
    end

    # Look for a _wiki directory
    def wiki_directory
      @wiki_directory ||= File.join(root_directory, '_wiki')
    end

    #
    def posts_directory
      @posts_directory ||= File.join(temp_directory, '_posts')
    end

    #
    def temp_directory
      @temp_directory ||= File.join(Dir.tmp, 'hyde')
    end

    # Iterate through _wiki files and copy anything that
    # matches `YYYY-DD-MM-` to _posts and anything else
    # to  ?
    def transform
      rm_r(temp_directory)
      mkdir_p(temp_directory)

      glob = File.join(wiki_directory, '**/*')
      Dir[glob].each do |path|
        next unless File.file?(path)

        case file
        when /^\d\d\d\d-\d\d-\d\d-/
          copy_to_posts(file)
        else
          copy_verbatum(file)
        end
      end
    end

    def copy_to_posts(file)
      src = file
      dst = File.join(posts_directory, File.basename(file))
      fileutils.cp(src, dst)
    end

    def copy_verbatum(file)
      src = file
      dst = file.sub(wiki_directory, temp_directory)
      fileutils.cp(src, dst)
    end

    #
    def mkdir_p(dir_name)
      fileutils.mkdir_p(dir_name) unless File.directory?(dir_name)
    end

    #
    def rm_r(dir_name)
      fileutils.rm_r(dir_name) if File.directory?(dir_name)
    end

    #
    # Copy temp_directory to root_directory. If sync option is
    # used then uses rsync to make the transfer, otherwise it is
    # just a straight copy.
    #
    # TODO: exclude anything in `.hydeignore` too.
    #
    def synchronize
      script  = "rsync -arv --del --exclude .git* --exclude _* '%s/' '%s/'"
      command = script % [temp_directory, root_directory]
      system command
    end

    alias sync synchronize

  end

end
