require 'securerandom'

str = File.read('sbc.html')

next_match = str[/<\/?[^>]*?>/]
if next_match
	matches = Hash.new
end

while next_match
	next_token = SecureRandom.urlsafe_base64( 20 )
	next_swap  = " (((" + next_token + "))) "
	matches[ next_token ] = next_match
	str.gsub!( next_match, next_swap )
	next_match = str[/<\/?[^>]*?>/]
end
puts str

matches.keys.each{ |k|
	str.gsub!( " (((" + k + "))) ", matches[k] )
}
puts str
