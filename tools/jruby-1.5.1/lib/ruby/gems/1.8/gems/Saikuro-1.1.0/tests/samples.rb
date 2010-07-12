

# CC : 1
def cc1
  "hello"
end

class CylcoIfTestClass

  # CC 2
  def cc2(arg)
    # Comment inside method
    if arg
      "True Arg"
    else
      "False Arg"
    end
  end

  # CC 3
  def cc3(arg1 = true, arg2 = false)
    if arg1
      "ARG1"
    elsif arg2
      "ARG2"
    else
      "Neither ARG1 or ARG2"
    end
  end

  # Also CC 3
  def cc3_2(arg1 = true, arg2 = false)
    if arg1
      if arg2
        "ARG1 and ARG2"
      else
        "ARG1"
      end
    else
    "No ARG1"
    end
  end


  def cc2_2(arg)
    v = "not arg"
    v = "arg" if arg
    v
  end

  def cc2_2(arg)
    if arg then
      "True Arg"
    else
      "False Arg"
    end
  end

  def cc2_ternary(arg)
    arg ? "True" : "False"
  end

  def cc1?(arg)
    cc2?
  end

end

class CycloException < StandardError; end

class CycloUnlessTestClass

  def cc2(arg = true)
    v = "cc2"
    unless arg
      arg = false
      v = "unless"
    end
    v
  end

  def cc2_2(arg)
    unless arg
      "not arg"
    else
      "arg"
    end
  end

  def cc2_3(arg)
    v = "arg"
    v = "trail" unless arg
    v
  end

end

class CycloDefTestClass

  def cc3
    "p1"
  rescue CycloException => ce
    "ce"
  rescue => err
    "se"
  end

  def cc2
    p = "p1"
  rescue CycloException => ce
    p = "CE"
  else
    p = "pelse"
  ensure
    p + "ensured"
  end

  def self.classm1_cc1
    "c1"
  end

  def CycloDefTestClass.classm2_cc1
    "c2"
  end

end

module CycloTestModule

  def cc4_case(arg)
    v = "1"
    case arg
    when "1"
      v += "c1"
    when "2"
      v << "c2"
    when "3", "4"
      v<< "c3/4"
    else
      v<< "else"
    end
    v
  end

  def while1_cc2(arg)
    v = "no while"
    while arg
      v = "while"
      arg = false
    end
    v
  end

  def while2_cc2(arg)
    v = "no while"
    arg = false while arg
    v
  end

  def while3_cc2(arg)
    v = "no while"
    begin
      v = "must while"
      arg = false
    end while arg
  end

  def while4_cc3(arg)
    v = "no while"
    while arg do
      v = "while"
      arg = false
    end
    v
  end

  def for_cc2(arg)
    v = 0
    for x in arg
      v += x
    end
    v
  end

 #  The do causes an error in the current implementation.
  def for2_cc2(arg)
    v = 0
    for x in arg do
      v += x
    end
    v
  end

  # def commented_out_method
  #   "Should not be seen"
  # end

  def block_cc2(arg)
    v = 0
    arg.each do |i|
      v += x
    end
    v
  end

  def block2_cc2(arg)
    v = 0
    arg.each { |i| v += x }
    v
  end

  def hash_cc1
    { :x => 1 }
  end

end

# Just to make sure classes wrapped in module show.
module CycloTestModule2

  class CycloUntilTestClass

    def until_cc2(arg)
      v = "until"
      until arg
        v = "no more until"
        arg = true
      end
      v
    end


    def until2_cc2(arg)
      v = "no until"
      arg = true until arg
      v
    end

    def until3_cc2(arg)
      v = "no until"
      begin
        v = "must until"
        arg = true
      end until arg
    end

    def until4_cc2(arg)
      v = "until"
      until arg do
        v = "no more until"
        arg = true
      end
      v
    end

  end

end

class SyntaxTests

  def here_docs_cc1
    str = <<-EOF
Hello
This is a here doc
EOF
    str
  end

  def SyntaxTests::colon_method_cc1
    "cc1"
  end

  def symbol_test_cc1(arg)
    { :s1 => 1,
      :class => "should not be a class",
    }
  end

  def hash_with_hash1(arg)
    h = {
      :x => {
        :q => arg
      }
    }
  end

  def hash_with_block_inside1(arg)
    data = {
      :x => 1,
      :y => arg.map do |a|
        a + 2
      end,
    }
  end

  def hash_with_block_inside2(arg)
    data = {
      :x => 1,
      :y => arg.map do |a|
        {
          :q => b_meth { a }
        }
      end,
    }
  end


=begin
     def begin_end_comment
       "Should not be shown"
     end
=end

end
