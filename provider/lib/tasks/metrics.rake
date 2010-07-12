require 'metric_fu'

ENV["JAVA_OPTS"] = "-Djruby.objectspace.enabled=true"

ENV["PATH"] += ":#{File.expand_path("../../../../tools/jruby-1.5.1/bin", __FILE__)}"

MetricFu::Configuration.run do |config|
  config.instance_variable_set "@code_dirs", ['vendor/plugins/oauth2_provider/app/controllers', 'vendor/plugins/oauth2_provider/app/models', 'vendor/plugins/oauth2_provider/lib']
  config.metrics = [:rcov]
  config.rcov[:rcov_opts] = ["--sort coverage", 
                 "--no-html", 
                 "--text-coverage",
                 "--no-color",
                 "--profile",
                 "--rails",
                 "--exclude .*",
                 "--include-file vendor/plugins/oauth2_provider/app/controllers,vendor/plugins/oauth2_provider/app/models,vendor/plugins/oauth2_provider/lib"]
  puts config.rcov.inspect
  # config.metrics = [:saikuro, :rcov]
  config.graphs = []
end