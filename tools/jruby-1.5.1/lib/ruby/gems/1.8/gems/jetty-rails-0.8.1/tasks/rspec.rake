begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'spec'
end
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run the specs under spec/"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run the specs under spec/ with rcov enabled"
Spec::Rake::SpecTask.new 'rcov' do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

desc "Generate HTML report for rspec examples"
Spec::Rake::SpecTask.new('spec_report') do |t|
  t.spec_opts = ["--format", "html:../doc/rspec/specs.html", "--diff"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.fail_on_error = false
end

# credits to http://blog.jayfields.com/2008/02/rake-task-overwriting.html
class Rake::Task
  def overwrite(&block)
    @actions.clear
    prerequisites.clear
    enhance(&block)
  end
end

Rake::Task['test'].overwrite do
  Rake::Task['spec'].invoke
end
