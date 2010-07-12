#
# a nice feature is that all fattrs are enumerated in the class.  this,
# combined with the fact that the getter method is defined so as to delegate
# to the setter when an argument is given, means bulk initialization and/or
# fattr traversal is very easy.
#
  require 'fattr'

  class C
    fattrs %w( x y z )

    def fattrs
      self.class.fattrs
    end

    def initialize
      fattrs.each_with_index{|a,i| send a, i}
    end

    def to_hash
      fattrs.inject({}){|h,a| h.update a => send(a)}
    end

    def inspect
      to_hash.inspect
    end
  end

  c = C.new
  p c.fattrs 
  p c 

  c.x 'forty-two' 
  p c.x
