# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'rubygems'
require 'rake/gempackagetask'

namespace :release do
  
  desc 'Update the changelog'
  task :changelog do
    File.open(File.join(File.dirname(__FILE__), '..', 'CHANGELOG'), 'w+') do |changelog|
      `git log -z --abbrev-commit vendor/plugins/oauth2_provider`.split("\0").each do |commit|
        next if commit =~ /^Merge: \d*/
        ref, author, time, _, title, _, message = commit.split("\n", 7)
        ref    = ref[/commit ([0-9a-f]+)/, 1]
        author = author[/Author: (.*)/, 1].strip
        time   = Time.parse(time[/Date: (.*)/, 1]).utc
        title.strip!

        changelog.puts "[#{ref} | #{time}] #{author}"
        changelog.puts '', "  * #{title}"
        changelog.puts '', message.rstrip if message
        changelog.puts
      end
    end
  end
  
  desc 'Create the oauth2_provider gem'
  task :gem => :changelog do
    Rake::Task[:copyright].invoke
    cd File.join(File.expand_path(File.dirname(__FILE__)), '..') do

      cp "#{RAILS_ROOT}/../README.textile", '.', :verbose => false
      cp "#{RAILS_ROOT}/../MIT-LICENSE.txt", '.', :verbose => false

      spec = Gem::Specification.new do |s|
        s.name = "oauth2_provider"
        s.version           = "0.1.0"
        s.author            = "ThoughtWorks, Inc."
        s.email             = "ketan@thoughtworks.com"
        s.homepage          = "http://github.com/ThoughtWorksStudios/oauth2_provider"
        s.platform          = Gem::Platform::RUBY
        s.summary           = "A Rails plugin to OAuth v2.0 enable your rails application"
        s.description       = "A Rails plugin to OAuth v2.0 enable your rails application. This plugin implements v09 of the OAuth2 draft spec http://tools.ietf.org/html/draft-ietf-oauth-v2-09."
        s.files             = Dir["**/*.*"] + ["#{s.name}.gemspec", "README.textile", "CHANGELOG"]
        s.has_rdoc          = false
        s.extra_rdoc_files  = ["README.textile", "MIT-LICENSE.txt"]
      end
      
      File.open("#{spec.name}.gemspec", "w") { |f| f << spec.to_ruby }
      
      sh "gem build #{spec.name}.gemspec"
      
      # move it into a proper directory
      rm_rf "#{RAILS_ROOT}/pkg", :verbose => false
      mkdir "#{RAILS_ROOT}/pkg", :verbose => false
      mv "#{spec.name}-#{spec.version}.gem", "#{RAILS_ROOT}/pkg", :verbose => false

      #cleanup
      rm "README.textile", :verbose => false
      rm "MIT-LICENSE.txt", :verbose => false
    end
  end
  
  desc 'Push the gem out to gemcutter'
  task :push => [:test, :gem] do
    
    puts <<-INSTRUCTIONS
    
      ==============================================================
      Instructions before you push out:
      * Make sure everything is good
      * Bump the version number in the `gem.rake' file
      * Check in
      * Run this task again to:
        * verify everything is good
        * generate a new gem with the new version number
      * Create a tag in git:
        $ git tag -a -m 'Tag for version X.Y.Z' 'vX.Y.Z'
        $ gem push pkg/oauth2_provider-X.Y.Z.gem
      ==============================================================
    INSTRUCTIONS
    # sh("gem push pkg/*.gem") do |res, ok|
    #   raise 'Could not push gem' if !ok
    # end
  end

end
