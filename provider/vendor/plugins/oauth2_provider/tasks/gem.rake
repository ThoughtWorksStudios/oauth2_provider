require 'rubygems'
require 'rake/gempackagetask'

desc 'Create a the oauth2_provider gem'
task :gem do
  cd File.join(File.expand_path(File.dirname(__FILE__)), '..') do
    
    cp "#{RAILS_ROOT}/../README.textile", '.'
    cp "#{RAILS_ROOT}/../MIT-LICENSE.txt", '.'
    
    spec = Gem::Specification.new do |s|
      s.name = "oauth2_provider"
      s.version           = "0.0.1"
      s.author            = "ThoughtWorks, Inc."
      s.email             = "ketan@thoughtworks.com"
      s.homepage          = "http://github.com/ThoughtWorksStudios/oauth2_provider"
      s.platform          = Gem::Platform::RUBY
      s.summary           = "A Rails plugin to OAuth v2.0 enable your rails application"
      s.description       = "A Rails plugin to OAuth v2.0 enable your rails application"
      s.files             = Dir["**/*.*"]
      s.has_rdoc          = false
      s.extra_rdoc_files  = ["README.textile", "MIT-LICENSE.txt"]
    end
    File.open("oauth2_provider.gemspec", "w") { |f| f << spec.to_ruby }
    rm_rf "#{RAILS_ROOT}/pkg"
    sh "gem build #{spec.name}.gemspec"
    mkdir "#{RAILS_ROOT}/pkg"
    mv "#{spec.name}-#{spec.version}.gem", "#{RAILS_ROOT}/pkg"
    
    rm "README.textile"
    rm "MIT-LICENSE.txt"
  end
end
