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
        matchstr = r.to_s
        case
        when matchstr[0] == "!"
          # we have an image
          m = "<img src=\"#{$2}\" title=\"#{$1}\" />"
        else
          m = "<a href=\"#{$2}\">#{$1}</a>"
        end
      }
      arg
    end
  end
end
