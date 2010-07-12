#
# multiple name=>default pairs can be given 
#
  require 'fattr'

  class C
    fattrs 'x' => 0b101000, 'y' => 0b10
  end

  c = C.new
  z = c.x + c.y
  p z #=> 42
