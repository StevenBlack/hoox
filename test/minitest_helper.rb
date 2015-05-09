$LOAD_PATH.unshift File.expand_path('../../examples', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'

require 'hoox'

# Implementation examples
require 'trivialparserhooks'
require 'transformationhooks'
require 'markdownhooks'
