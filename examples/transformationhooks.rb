module Hoox
  # Public: A hook to tokenize tab symbols before hook delegation
  class TabHideHook < Hoox::Hook
    def initialize
      # The token to substitite for tabs
      @tab_subst="~!~ "
    end

    # Substiute tabs for tokens
    def preprocess(arg)
      if arg[/\t/]
        arg.gsub!( /\t/, @tab_subst )
      end
      arg
    end

    # Substitute the tokens for tabs
    def postprocess(arg)
      arg.gsub!( @tab_subst, "\t" )
      arg
    end
  end

  # Public: Strip away pre code tags for processing, and
  # restore upon exit
  class HtmlPreElementHideHook < Hoox::RegexHideHook
    def initialize
      # The token to substitite for pre elements
      @regex = "<pre.*?<\/pre>"
      super
    end
  end

  # Publlic: Hide all HTML tags from downstream hooks
  class HtmlTagToken < Hoox::RegexHideHook
    def initialize
      # The token to substitite for tabs
      @regex  = "/<\/?[^>]*?>/"
      super
    end
  end

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
