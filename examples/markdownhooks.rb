module Hoox
  class MarkdownHyperlinkHook < Hoox::Hook
    def applies(arg)
      arg.include? "]("
    end
    # Internal: Swap the Markdown Link tokens for HTML a elements
    def execute( arg )
      arg.gsub!( /\[(.*?)\]\((.*?)\)/ ) { |m|
        m = "<a href=\"#{$2}\">#{$1}</a>"
      }
      arg
    end
  end
end
