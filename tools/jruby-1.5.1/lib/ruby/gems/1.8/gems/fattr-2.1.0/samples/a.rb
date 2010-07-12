#
# basic usage is like attr, but note that fattr defines a suite of methods
#
  require 'fattr'

  class C
    fattr 'a'
  end

  c = C.new

  c.a = 42
  p c.a                 #=> 42
  p 'forty-two' if c.a? #=> 'forty-two'

#
# fattrs works on object too 
#
  o = Object.new
  o.fattr 'answer' => 42
  p o.answer           #=> 42
