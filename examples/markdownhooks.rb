module Hoox
  # Public: This hook reckons markdown-style links
  #
  class MarkdownHyperlinkHook < Hoox::Hook

    def applies(arg)
      # this string applies to all conventional markdown links.
      arg.include? "]("
    end

    # Internal: Swap the Markdown Link tokens for HTML a elements
    def execute( arg )
      arg.gsub!( /\!??\[(.*?)\]\((.*?)\)/ ) { |m|
        r = Regexp.last_match
        c1 = r[1]
        c2 = r[2]
        c3 = nil
        # If we have anciliary text...
        if c2.scan(/(?<=").+?(?=")/m).length == 1
          # Islate it into c3
          c3 = c2.scan(/(?<=").+?(?=")/m)[0]
          c2 = c2.sub( "\"#{c3}\"", "" ).strip
        end

        case
        when r[0][0] == "!"
          # we have an image
          if c3
            m = "<img src=\"#{c2}\" title=\"#{c1}\ alt=\"#{c3}\" />"
          else
            m = "<img src=\"#{c2}\" title=\"#{c1}\" />"
          end
        else
          if c3
            m = "<a href=\"#{c2}\" title=\"#{c3}\">#{c1}</a>"
          else
            m = "<a href=\"#{c2}\">#{c1}</a>"
          end
        end
      }
      arg
    end
  end
end
