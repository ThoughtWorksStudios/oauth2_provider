require 'rubygems'
require 'rake/gempackagetask'

namespace :oauth2_provider do

  desc 'Turn this plugin into a gem.'
  task :gem do
    cd File.join(File.expand_path(File.dirname(__FILE__)), '..') do
      spec = Gem::Specification.new do |s|
        s.name = "oauth2_provider"
        s.version           = "0.0.1"
        s.author            = "ThoughtWorks, Inc."
        s.email             = "ketan@thoughtworks.com"
        s.homepage          = "http://github.com/ThoughtWorksStudios/oauth2_provider"
        s.platform          = Gem::Platform::RUBY
        s.summary           = "OAuth2 Provider Plugin"
        s.files             = Dir["**/*.*"]
        s.has_rdoc          = false
        s.extra_rdoc_files  = ["README.textile"]
        s.extra_rdoc_files  = ["MIT-LICENSE.txt"]
      end
      File.open("oauth2_provider.gemspec", "w") { |f| f << spec.to_ruby }
      rm_rf "#{RAILS_ROOT}/pkg"
      sh "gem build #{spec.name}.gemspec"
      mkdir "#{RAILS_ROOT}/pkg"
      mv "#{spec.name}-#{spec.version}.gem", "#{RAILS_ROOT}/pkg"
    end
  end
  
end

