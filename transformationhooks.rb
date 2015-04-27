require './hooks'

# Public: A parser hook to tokenize tab symbols before hook delegation
class Tabhidehook < ParserHook

  def initialize
    # The token to substitite for tabs
    @tab_subst="~!~ "
  end

  # Substiute tabs for tokens
  def preprocess(arg)
  	arg.gsub!( /\t/, @tab_subst )
  end

  # Substitute the tokens for tabs
  def postprocess(arg)
  	arg.gsub!( @tab_subst, "\t" )
  end
end



# <\/?[^>]*?>