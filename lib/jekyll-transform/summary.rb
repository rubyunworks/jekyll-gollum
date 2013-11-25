module Jekyll
  module AssetFilter
    def post_summary(post)
      html   = post["content"]
      pindex = html.index("</p>")
      if pindex
        output = html[0...pindex]
      else
        output = html[0..-1]
      end
      output << %{ <a class="readmore" href="#{post["url"]}">Read more</a>}
      output << "</p>"
    end
    alias_method :page_summary, :post_summary
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
