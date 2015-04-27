require './hooks'
require 'securerandom'

# Public: A parser hook to tokenize tab symbols before hook delegation
class TabHideHook < ParserHook
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

# Oubllic: Hide all HTML tags from downstream hooks
class HtmlTagToken < ParserHook
  def initialize
    # The token to substitite for tabs
    @matches      = Hash.new
    @token_prefix = " ((("
    @token_suffix = "))) "
  end

  # Remove all HTML tags
  def preprocess(arg)
    next_match = arg[/<\/?[^>]*?>/]
    while next_match
      next_token = SecureRandom.urlsafe_base64( 20 )
      next_swap  = @token_prefix + next_token + @token_suffix
      @matches[ next_token ] = next_match
      arg.gsub!( next_match, next_swap )
      next_match = arg[/<\/?[^>]*?>/]
    end
    arg
  end

  # Restore all HTML tags
  def postprocess(arg)
    @matches.keys.each{ |k|
      arg.gsub!( @token_prefix + k + @token_suffix, @matches[k] )
    }
    arg
  end
end
