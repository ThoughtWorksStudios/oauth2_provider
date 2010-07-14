ENV["PATH"] += ":#{File.expand_path("../../../../tools/jruby-1.5.1/bin", __FILE__)}" if RUBY_PLATFORM =~ /java/

namespace :metrics do

  desc "generate saikuro treemap"
  task :saikuro_treemap do
    Saikuro.generate_treemap #:code_dirs => ['vendor/plugins/oauth2_provider/app/controllers', 
#      'vendor/plugins/oauth2_provider/app/models', 
#      'vendor/plugins/oauth2_provider/lib'
#    ]
  end
end

module Saikuro
  
  DEFAULT_CONFIG = {
    :code_dirs => ['app/controllers', 'app/models', 'app/helpers' 'lib'],
    :output_file => 'reports/saikuro_treemap.html',
    :saikuro_args => [
      "--warn_cyclo 5",
      "--error_cyclo 7",
      "--formater text",
      "--cyclo --filter_cyclo 0",
      "--output_directory tmp/saikuro"]
  }
  
  def self.generate_treemap(config={})
    require 'erb'
    
    config = DEFAULT_CONFIG.merge(config)
    
    options_string = config[:saikuro_args] + config[:code_dirs].collect { |dir|  "--input_directory '#{dir}'" }
    
    rm_rf "tmp/saikuro"
    sh %{saikuro #{options_string.join(' ')}} do |ok, response| 
      unless ok 
        puts "Saikuro failed with exit status: #{response.exitstatus}" 
        exit 1 
      end 
    end
    
    saikuro = Parser.parse("tmp/saikuro")
    @ccn_node = create_ccn_root_node(saikuro)

    FileUtils.mkdir_p(File.dirname(config[:output_file]))
    File.open(config[:output_file], 'w') do |f|
      f << ERB.new(File.read("metric_fu_templates/saikuro.html.erb")).result(binding)
    end
  end
  
  def self.create_ccn_root_node(saikuro)
    root_node = CCNNode.new('', '', :data => {})
    saikuro.each {|f|
      f[:classes].each do |c|
        class_node_name = c[:class_name]
        namespaces = class_node_name.split("::")[0..-2]
        namespaces.each_with_index do |name, i|
          root_node.find_or_create_node(namespaces[0..i])
        end    

        class_node = CCNNode.new(class_node_name, class_node_name.split("::").last, :data => {:complexity => c[:complexity], :lines => c[:lines], :$area => c[:lines], :$color => '#101010'})

        parent = (root_node.find_node(class_node_name.split("::")[0..-2]) || root_node)
        parent.add_child(class_node)

        c[:methods].each do |m|
          method_node_name = m[:name]
          method_node = CCNNode.new(method_node_name, method_node_name.split('#').last, :data => {:complexity => m[:complexity], :lines => m[:lines], :$area => m[:lines], :$color => ccn_color(m[:complexity])})
          class_node.add_child(method_node)
        end
      end
    }

    root_node
  end
  
  def self.ccn_color(ccn)
    return "#AE0000" if ccn > 10
    return "#006500" if ccn <= 5
    return "#4545C2"
  end
  
    
  class Parser
    def self.parse(saikuro_out_dir)
      files = Dir[File.join(saikuro_out_dir, "/**/*.html")].collect do |path|
        SFile.new(path) if SFile.is_valid_text_file?(path)
      end

      files.compact!

      files = files.sort_by do |file|
        file.elements.
             max {|a,b| a.complexity.to_i <=> b.complexity.to_i}.
             complexity.to_i
      end.reverse

      files.each do |file|
        file.elements.each do |element|
          element.defs.each do |defn|
            defn.name = "#{element.name}##{defn.name}"
          end
        end
      end

      files.collect(&:to_h)
    end
  end
  
  class SFile
     attr_reader :elements

     def initialize(path)
       @path = path
       @file_handle = File.open(@path, "r")
       @elements = []
       get_elements
     ensure
       @file_handle.close if @file_handle
     end

     def self.is_valid_text_file?(path)
       File.open(path, "r") do |f|
         if f.eof? || !f.readline.match(/--/)
           return false
         else
           return true
         end
       end
     end

     def filename
       File.basename(@path, '_cyclo.html')
     end

     def to_h
       merge_classes
       {:classes => @elements}
     end

     def get_elements
       begin
         while (line = @file_handle.readline) do
           return [] if line.nil? || line !~ /\S/
           element ||= nil
           if line.match /START/
             unless element.nil?
               @elements << element
               element = nil
             end
             line = @file_handle.readline
             element = ParsingElement.new(line)
           elsif line.match /END/
             @elements << element if element
             element = nil
           else
             element << line if element
           end
         end
       rescue EOFError
         nil
       end
     end


     def merge_classes
       new_elements = []
       get_class_names.each do |target_class|
         elements = @elements.find_all {|el| el.name == target_class }
         complexity = 0
         lines = 0
         defns = []
         elements.each do |el|
           complexity += el.complexity.to_i
           lines += el.lines.to_i
           defns << el.defs
         end

         new_element = {:class_name => target_class,
                        :complexity => complexity,
                        :lines => lines,
                        :methods => defns.flatten.map {|d| d.to_h}}
         new_element[:methods] = new_element[:methods].
                                 sort_by {|x| x[:complexity] }.
                                 reverse

         new_elements << new_element
       end
       @elements = new_elements if new_elements
     end

     def get_class_names
       class_names = []
       @elements.each do |element|
         unless class_names.include?(element.name)
           class_names << element.name
         end
       end
       class_names
     end

   end

   class CCNNode
     def initialize(id, name, attributes = {})
       @name = name
       @id = id
       attributes.each do |k, v|
         instance_variable_set("@#{k}", v)
       end
       @children ||= []
     end

     def add_child(child)
       @children << child
     end

     def find_node(path)
       return self if path.join("::") == @id

       # Eumerable#find is buggy!
       @children.each do |child|
         if r = child.find_node(path)
           return r 
         end
       end
       return nil
     end

     def find_or_create_node(path)
       find_node(path) || create_node(path)
     end

     def create_node(path)
       parent = (path.size == 1) ? self : self.find_node(path[0..-2])
       parent.add_child(CCNNode.new(path.join("::"), path.last))
     end
   end


  class ParsingElement
    TYPE_REGEX=/Type:(.*) Name/
    NAME_REGEX=/Name:(.*) Complexity/
    COMPLEXITY_REGEX=/Complexity:(.*) Lines/
    LINES_REGEX=/Lines:(.*)/

    attr_reader :complexity, :lines, :defs, :element_type
    attr_accessor :name

    def initialize(line)
      @line = line
      @element_type = line.match(TYPE_REGEX)[1].strip
      @name = line.match(NAME_REGEX)[1].strip
      @complexity = line.match(COMPLEXITY_REGEX)[1].strip
      @lines = line.match(LINES_REGEX)[1].strip
      @defs = []
    end

    def <<(line)
      @defs << ParsingElement.new(line)
    end

    def to_h
      base = {:name => @name, :complexity => @complexity.to_i, :lines => @lines.to_i}
      unless @defs.empty?
        defs = @defs.map do |my_def|
          my_def = my_def.to_h
          my_def.delete(:defs)
          my_def
        end
        base[:defs] = defs
      end
      return base
    end
  end
end

