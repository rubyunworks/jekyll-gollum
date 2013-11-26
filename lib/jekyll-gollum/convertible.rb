module Jekyll
  module Convertible

    # Transform the contents based on the content type.
    #
    # Returns nothing.
    def transform
      self.content = converter.convert(preprocess(self.content))
    rescue => e
      Jekyll.logger.error "Conversion error:", "There was an error converting" +
        " '#{self.path}'."
      raise e
    end

    # Callback for plugins to preprocess content prior to templating.
    def preprocess(content)
      content = process_wikiwords(content)
      #content = process_highlight(content)
    end

    # Support for WikiWords (basically).
    def process_wikiwords(full_document)
      doc = full_document.dup
      doc.gsub!(/\[\[([A-Za-z0-9_\-\ ]+)\]\]/) do |match|
        name = $1
        link = name.gsub(/\s+/, '-')
        if md = /^(\d\d\d\d-\d\d-\d\d-)/.match(link)
          date = md[1].gsub('-', '/')
          link = link.sub(md[1], date)
        end
        "[#{name}](#{link}.html)"
      end
      return doc
    end

    # Highlights should be raw.
    def process_highlight(full_document)
      return full_document if site.config['markdown'] == 'redcarpet'

      doc = full_document.dup
      doc.gsub!(/```(.*?)\n(.*?)\n```/m) do |match|
        #"```#{$1}\n{% raw %}\n#{$2}\n{% endraw %}\n```"
        "{% highlight #{$1} %}\n#{$2}\n{% endhighlight %}\n"
      end
      return doc
    end

  end
end

