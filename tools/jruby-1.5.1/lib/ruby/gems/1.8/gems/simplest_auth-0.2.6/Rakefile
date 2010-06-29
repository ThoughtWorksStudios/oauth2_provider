require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/simplest_auth/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name            = 'simplest_auth'
  s.version         = SimplestAuth::Version.to_s
  s.summary         = "Simple implementation of authentication for Rails"
  s.author          = 'Tony Pitale'
  s.email           = 'tony.pitale@viget.com'
  s.homepage        = 'http://viget.com/extend'
  s.files           = %w(README.textile Rakefile) + Dir.glob("lib/**/*")
  s.test_files      = Dir.glob("test/**/*_test.rb")
  
  s.add_dependency('bcrypt-ruby', '~> 2.1.1')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

begin
  require 'rcov/rcovtask'
  
  desc "Generate RCov coverage report"
  Rcov::RcovTask.new(:rcov) do |t|
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts << "-x lib/simplest_auth.rb -x lib/simplest_auth/version.rb"
  end
rescue LoadError
  nil
end

task :default => 'test'
