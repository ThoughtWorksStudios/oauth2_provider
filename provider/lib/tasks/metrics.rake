require 'metric_fu'

ENV["JAVA_OPTS"] = "-Djruby.objectspace.enabled=true"

ENV["PATH"] += ":#{File.expand_path("../../../../tools/jruby-1.5.1/bin", __FILE__)}" if RUBY_PLATFORM =~ /java/

code_dirs = ['vendor/plugins/oauth2_provider/app/controllers', 'vendor/plugins/oauth2_provider/app/models', 'vendor/plugins/oauth2_provider/lib']
# code_dirs = Dir["vendor/rails/*/*"] - Dir['vendor/rails/*/test']
puts code_dirs
MetricFu::Configuration.run do |config|
  config.metrics = [:saikuro]
  config.saikuro[:input_directory] = code_dirs
  config.rcov[:rcov_opts] = ["--sort coverage", 
                 "--no-html", 
                 "--text-coverage",
                 "--no-color",
                 "--profile",
                 "--rails",
                 "--exclude .*",
                 "--include-file #{code_dirs.join(',')}"]
  config.graphs = []
end



module Metrics
  class Node
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
      parent.add_child(Node.new(path.join("::"), path.last))
    end
  end
end

module MetricFu
  class Template
    def template(section)
      File.join("metric_fu_templates",  section.to_s + ".html.erb")
    end
  end
end


# require 'rubygems'
# require 'active_support'
# require 'json'
# require 'pp'
# root_node = Metrics::Node.new('root', 'root', :data => {})
# root_node.create_node(["A"])
# root_node.create_node(["A", "B"])
# p $root_node.find_node(["A", "B"]).instance_variable_get("@id")
# puts "root_node.to_json => #{root_node.to_json}"
