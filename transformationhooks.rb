require './hoox'

# Public: A parser hook to tokenize tab symbols before hook delegation
class TabHideHook < Hoox::ParserHook
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
class HtmlPreElementHideHook < Hoox::RegexHideParserhook
  def initialize
    # The token to substitite for pre elements
    @regex = "<pre.*?<\/pre>"
    super
  end
end

# Publlic: Hide all HTML tags from downstream hooks
class HtmlTagToken < Hoox::RegexHideParserhook

  def initialize
    # The token to substitite for tabs
    @regex  = "/<\/?[^>]*?>/"
    super
  end


end
