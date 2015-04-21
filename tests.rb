load 'hooks.rb'

# ========================
# Sample implementation
# ========================
class TalkyHook < AbstractHook
  def execute( *args )
    represent
  end
  def represent
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
    if ! super args
      puts "-------"
      puts args.join( " " )
    end
  end
end


z = TalkyAnchor.new( "An anchor with a couple of hook chains" )
z.ahook << x << y
z.process

o = Hook1.new( "A hook chain with string class names passed-in" )
o.sethook( "TalkyHook", "TalkyHook", "TalkyHook" )
o.process
