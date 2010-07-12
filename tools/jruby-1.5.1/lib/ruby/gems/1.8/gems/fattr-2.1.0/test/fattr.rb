require 'fattr'

Testing Fattr do
  testing 'that a basic set of methods are defined' do
    o = Class.new{ fattr :a }.new
    %w( a a= a? ).each do |msg|
      assert("respond_to?(#{ msg.inspect })"){ o.respond_to?(msg) }
    end
  end

  testing 'that the basic usage works' do
    o = Class.new{ fattr :a }.new
    assert{ o.a==nil }
    assert{ o.a=42 }
    assert{ o.a(42.0) }
    assert{ o.a? }
  end

  testing 'that simple defaults work' do
    o = Class.new{ fattr :a => 42 }.new
    assert{ o.a==42 }
  end

  testing 'that block defaults work' do
    n = 41
    o = Class.new{ fattr(:a){ n += 1 } }.new
    assert{ o.a==42 }
    assert{ n==42 }
  end

  testing 'that > 1 fattrs can be defined at once' do
    o = Class.new{ fattr :a, :b }.new
    %w( a a= a? b b= b? ).each do |msg|
      assert("respond_to?(#{ msg.inspect })"){ o.respond_to?(msg) }
    end
  end

  testing 'that > 1 fattrs with defaults can be defined at once' do
    o = Class.new{ fattr :a => 40, :b => 2 }.new
    assert{ o.a+o.b==42 }
  end

  testing 'that fattrs can be retrieved from the object' do
    c = Class.new{ fattr :a, :b, :c; self }
    assert{ c.fattrs.sort === %w[a b c] }
  end

  testing 'getters as setters' do
    o = Class.new{ fattr :a }.new
    assert{ o.a(42) }
    assert{ o.a==42 }
  end

  testing 'module fattrs' do
    m = Module.new{ class << self; fattr :a => 42; end; }
    assert{ m.a==42 }
  end

  testing 'module fattr shortcut' do
    m = Module.new{ Fattr :a => 42 }
    assert{ m.a==42 }
  end

  testing 'that fattrs support simple class inheritable attributes' do
    a = Class.new{ Fattr :x, :default => 42, :inheritable => true }
    b = Class.new(a)
    c = Class.new(b)

    def a.name() 'a' end
    def b.name() 'b' end
    def c.name() 'c' end

    assert{ c.x==42 }
    assert{ b.x==42 }
    assert{ a.x==42 }

    assert{ b.x=42.0 }
    assert{ b.x==42.0 }
    assert{ a.x==42 }

    assert{ a.x='forty-two' }
    assert{ a.x=='forty-two' }
    assert{ b.x==42.0 }

    assert{ b.x! }
    assert{ b.x=='forty-two' }
    assert{ b.x='FORTY-TWO' }

    assert{ c.x! }
    assert{ c.x=='FORTY-TWO' }
  end

  testing 'a list of fattrs can be declared at once' do
    list = %w( a b c )
    c = Class.new{ fattrs list }
    list.each do |attr|
      assert{ c.fattrs.include?(attr.to_s) }
      assert{ c.fattrs.include?(attr.to_sym) }
    end
  end
end







BEGIN {
  require 'test/unit'
  STDOUT.sync = true
  $:.unshift 'lib'
  $:.unshift '../lib'
  $:.unshift '.'

  def Testing(*args, &block)
    Class.new(Test::Unit::TestCase) do
      def self.slug_for(*args)
        string = args.flatten.compact.join('-')
        words = string.to_s.scan(%r/\w+/)
        words.map!{|word| word.gsub %r/[^0-9a-zA-Z_-]/, ''}
        words.delete_if{|word| word.nil? or word.strip.empty?}
        words.join('-').downcase
      end

      @@testing_subclass_count = 0 unless defined?(@@testing_subclass_count) 
      @@testing_subclass_count += 1
      slug = slug_for(*args).gsub(%r/-/,'_')
      name = ['TESTING', '%03d' % @@testing_subclass_count, slug].delete_if{|part| part.empty?}.join('_')
      name = name.upcase!
      const_set(:Name, name)
      def self.name() const_get(:Name) end

      def self.testno()
        '%05d' % (@testno ||= 0)
      ensure
        @testno += 1
      end

      def self.testing(*args, &block)
        method = ["test", testno, slug_for(*args)].delete_if{|part| part.empty?}.join('_')
        define_method("test_#{ testno }_#{ slug_for(*args) }", &block)
      end

      alias_method '__assert__', 'assert'

      def assert(*args, &block)
        if block
          label = "assert(#{ args.join ' ' })"
          result = nil
          assert_nothing_raised{ result = block.call }
          __assert__(result, label)
          result
        else
          result = args.shift
          label = "assert(#{ args.join ' ' })"
          __assert__(result, label)
          result
        end
      end

      module_eval &block
      self
    end
  end
}
