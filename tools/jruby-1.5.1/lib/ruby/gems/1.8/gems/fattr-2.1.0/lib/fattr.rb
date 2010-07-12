module Fattr
  Fattr::Version = '2.1.0' unless Fattr.const_defined?(:Version)
  def self.version() Fattr::Version end

  class List < ::Array
    def << element
      super
      self
    ensure
      uniq!
      index!
    end

    def index!
      @index ||= Hash.new
      each{|element| @index[element.to_s] = true}
    end

    def include?(element)
      @index ||= Hash.new
      @index[element.to_s] ? true : false
    end

    def initializers
      @initializers ||= Hash.new
    end
  end

  def fattrs(*args, &block)
    unless args.empty?
      returned = Hash.new

      args.flatten!
      args.compact!

      all_hashes = args.all?{|arg| Hash===arg}

      names_and_configs = {}

      if all_hashes
        args.each do |hash|
          hash.each do |key, val|
            name = key.to_s
            config = Hash===val ? val : {:default => val}
            names_and_configs[name] = config
          end
        end
      else
        config = Hash===args.last ? args.pop : {}
        names = args.select{|arg| Symbol===arg or String===arg}.map{|arg| arg.to_s}
        names.each do |name|
          names_and_configs[name] = config
        end
      end

      initializers = __fattrs__.initializers

      names_and_configs.each do |name, config|
        raise(NameError, "bad instance variable name '@#{ name }'") if("@#{ name }" =~ %r/[!?=]$/o)

        name = name.to_s

        default = nil
        default = config[:default] if config.has_key?(:default)
        default = config['default'] if config.has_key?('default')

        inheritable = false
        if Module===self
          inheritable = config[:inheritable] if config.has_key?(:inheritable)
          inheritable = config['inheritable'] if config.has_key?('inheritable')
        end

        initialize = (
          if inheritable
            lambda do
              parents = ancestors[1..-1]
              catch(:value) do
                parents.each do |parent|
                  throw(:value, parent.send(name)) if parent.respond_to?(name)
                end
                block ? block.call : default
              end
            end
          else
            block || lambda{ default }
          end
        )

        initializer = lambda do |this|
          Object.instance_method('instance_eval').bind(this).call(&initialize)
        end

        initializer_id = initializer.object_id

        __fattrs__.initializers[name] = initializer

        compile = lambda do |code|
          begin
            module_eval(code)
          rescue SyntaxError
            raise(SyntaxError, "\n#{ code }\n")
          end
        end

      # setter, block invocation caches block
        code = <<-code
          def #{ name }=(*value, &block)
            value.unshift block if block
            @#{ name } = value.first
          end
        code
        compile[code]

      # getter, providing a value or block causes it to acts as setter
        code = <<-code
          def #{ name }(*value, &block)
            value.unshift block if block
            return self.send('#{ name }=', value.first) unless value.empty?
            #{ name }! unless defined? @#{ name }
            @#{ name }
          end
        code
        compile[code]

      # bang method re-calls any initializer given at declaration time
        code = <<-code
          def #{ name }!
            initializer = ObjectSpace._id2ref #{ initializer_id }
            self.#{ name } = initializer.call(self)
            @#{ name }
          end
        code
        compile[code]

      # query simply defers to getter - cast to bool
        code = <<-code
          def #{ name }?
            self.#{ name }
          end
        code
        compile[code]

        fattrs << name
        returned[name] = initializer 
      end

      returned
    else
      begin
        __fattr_list__
      rescue NameError
        singleton_class =
          class << self
            self
          end
        klass = self
        singleton_class.module_eval do
          fattr_list = List.new 
          define_method('fattr_list'){ klass == self ? fattr_list : raise(NameError) }
          alias_method '__fattr_list__', 'fattr_list'
        end
        __fattr_list__
      end
    end
  end

  %w( __fattrs__ __fattr__ fattr ).each{|dst| alias_method(dst, 'fattrs')}
end

class Module
  include Fattr

  def Fattrs(*args, &block)
    class << self
      self
    end.module_eval{ __fattrs__(*args, &block) }
  end

  def Fattr(*args, &block)
    class << self
      self
    end.module_eval{ __fattr__(*args, &block) }
  end
end

class Object
  def fattrs(*args, &block)
    class << self
      self
    end.__fattrs__(*args, &block)
  end
  %w( __fattrs__ __fattr__ fattr ).each{|dst| alias_method(dst, 'fattrs')}
end
