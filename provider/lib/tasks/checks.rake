# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

PROJECT_COPYRIGHT = [
  "# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)",
  "# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)"
]

desc "Check copyright notice in all ruby scripts in the distribution"
task :copyright do
  puts "** Verifying copyright notices on all ruby scripts in the distribution..."
  need_copyright = []
  
  Dir['{lib,test,app,vendor/plugins/oauth2_provider}/**/*{.rb,rake}'].each do |file|
    file = File.expand_path(file)
    lines = File.readlines(file).map{|l| l.chomp}
    unless lines.first(PROJECT_COPYRIGHT.size) == PROJECT_COPYRIGHT
      need_copyright << file
    end
  end
  
  unless need_copyright.empty?
    require 'pp'
    puts "** The following files are missing copyrights:"
    need_copyright.each { |file| puts file }
    raise 'Check failed!'
  end
  
end
