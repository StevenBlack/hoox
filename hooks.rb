class AbstractHook
	@oHook =  nil

	def sethook( *args )
		args.each { |arg| 
			if @hook.nil?
				@hook = arg
			else
				@hook.sethook( arg )
			end
		}
	end  

	def process( *args )
		if preprocess( args )
			execute( args )
		end

		if ! @hook.nil?
			@hook.process( args )
		end
		postprocess()

	end

	def preprocess( *args )
		# Override to implement whether this hook executes
		true
	end

	def postprocess( *args )

	end

	def execute( *args )

		# Implement the hook here
	end
end

class HookAnchor < AbstractHook
	attr_accessor :ahook

	def initialize( *args )
     self.ahook = [] # on object creation initialize this to an array
	end

	def execute( *args )
		@ahook.each { | hook | 
			hook.process( args )
		}
	end
end

class TalkyHook < AbstractHook
	def execute( *args )
		puts self.class.name
	end
end

class Hook1 < TalkyHook 
	def initialize( *args )
		puts "-------"
		puts args.join( " " )
	end
end

class Hook2 < TalkyHook 
end

class Hook3 < TalkyHook 
end

x = Hook1.new( "Hooks assigned discretely" )
x.sethook( Hook2.new )
x.sethook( Hook3.new )
x.process


y = Hook1.new( "Hooks assigned in batch" )
y.sethook( Hook2.new , Hook3.new )
y.process


class TalkyAnchor < HookAnchor
	def initialize( *args )
		super args
		puts "-------"
		puts args.join( " " )
	end
end


z = TalkyAnchor.new( "An anchor with a couple of hook chains" )
z.ahook << x << y
z.process
