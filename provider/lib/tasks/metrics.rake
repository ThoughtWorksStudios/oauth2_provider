require 'metric_fu'

ENV["JAVA_OPTS"] = "-Djruby.objectspace.enabled=true"

ENV["PATH"] += ":#{File.expand_path("../../../../tools/jruby-1.5.1/bin", __FILE__)}" if RUBY_PLATFORM =~ /java/

code_dirs = ['vendor/plugins/oauth2_provider/app/controllers', 'vendor/plugins/oauth2_provider/app/models', 'vendor/plugins/oauth2_provider/lib']
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
    def initialize(name, attributes = {})
      @name = name
      @id = name
      attributes.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
      @children ||= []
    end

    def add_child(child)
      @children << child
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
