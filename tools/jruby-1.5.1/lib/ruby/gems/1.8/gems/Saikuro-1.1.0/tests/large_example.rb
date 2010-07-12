# These are methods to show warning and errors
# The code is nonsense it is used to make large complexity values.

class ExtraTests

  # CC 8
  def warn_method_cc8(a, b, c)
    q, r, s = nil
    if a
      q = a + c
    end
    if b
      b = r - q
    end
    if !c
      s = r + b
    end
    if b > q || c
      a = c + q
    end
    if a
      c = b
    end
    if c
      b = a
    end
    if s
      c = s + a
    end    
    # large token count 
    a + b + c + q + r + s + a + b + c + q + r + s + a + b + c + q + r + s + a + b + c + q + r + s
  end

  # CC 11
  def error_method_cc11(a, b, c)
    q, r, s = nil
    if a
      q = a + c
    end
    if b
      b = r - q
    end
    if !c
      s = r + b
    end
    if b > q || c
      a = c + q
    end
    if a
      c = b
    end
    if c
      b = a
    end
    if s
      c = s + a
    end
    if q
      r = s + q
    end
    if r
      s = a + r
    end    
    a + b + c + q + r + s + a + b + c + q + r + s
  rescue => err
    puts err
  end
    

end
