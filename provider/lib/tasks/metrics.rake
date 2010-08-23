# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

ENV["PATH"] += ":#{File.expand_path("../../../../tools/jruby-1.5.1/bin", __FILE__)}" if RUBY_PLATFORM =~ /java/

namespace :metrics do
  
  desc "Generate Cyclomatic Complexity treemap"
  task :saikuro_treemap do
    begin
      require 'saikuro_treemap'
    rescue LoadError
      raise 'Could not find the saikuro_treemap gem, please run `gem install saikuro_treemap` to get some metrics'
    end
    
    SaikuroTreemap.generate_treemap :code_dirs => [
      'vendor/plugins/oauth2_provider/app/controllers', 
      'vendor/plugins/oauth2_provider/app/models', 
      'vendor/plugins/oauth2_provider/lib'
    ]
  end

  desc "Show Cyclomatic Complexity in your browser"
  task :ccn_show => :saikuro_treemap do
    `open reports/saikuro_treemap.html`
  end

end
