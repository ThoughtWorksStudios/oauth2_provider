#
# class variable inheritance is supported simply
#
  require 'fattr'

  class A
    Fattr :x, :default => 42, :inheritable => true
  end

  class B < A
  end

  class C < B
  end

  p C.x #=> 42

  A.x = 42.0
  B.x = 'forty-two'

  p A.x #=> 42.0
  p B.x #=> 'forty-two'
  p C.x #=> 42

  C.x! # re-initialize from closest ancestor (B)

  p A.x #=> 42.0
  p B.x #=> 'forty-two'
  p C.x #=> 'forty-two'
