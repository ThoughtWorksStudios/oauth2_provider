require 'rubygems'
require 'fattr'

class A
  class << A
    fattr(:x, :inheritable => true){ 42 }
  end
end

class B < A; end

class C < B; end


p C.x
p B.x
p A.x
puts

B.x = 42.0

p C.x
p B.x
p A.x
puts

C.x! # force re-initialization from parent(s)

p C.x
p B.x
p A.x
puts


class K
end
module M
  fattr(:x, :inheritable => true){ 42 }
end
K.extend(M)

p K.x
