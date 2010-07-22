begin
  require 'rcov/rcovtask'
rescue LoadError
  raise 'Could not find the rcov gem, please run `gem install rcov` to get some metrics'
end

namespace :test do 
  
  namespace :coverage do
    
    desc "Delete aggregate coverage data."
    task :clean do
      mkdir_p "reports/coverage"
      rm_f "reports/coverage/coverage.data"
    end
    
    desc "Open code coverage reports in a browser."
    task :show => 'test:coverage' do
      system("open reports/coverage/functional/index.html")
    end
    
  end
  
  desc 'Aggregate code coverage for unit, functional and integration tests'
  task :coverage => "test:coverage:clean"
  
  
  %w[unit functional].each do |target|
    namespace :coverage do
      Rcov::RcovTask.new(target) do |t|
        t.libs << "test"
        t.test_files = FileList["test/#{target}/**/*_test.rb"]
        t.output_dir = "reports/coverage/#{target}"
        t.verbose = true
        t.rcov_opts << '--rails --aggregate reports/coverage/coverage.data'
        t.rcov_opts << '--exclude gems --exclude app'
        t.rcov_opts << '--exclude "yaml,parser.y,racc,(erb),(eval),(recognize_optimized),erb"' if RUBY_PLATFORM =~ /java/
        t.rcov_opts << '--include-file "vendor/plugins/oauth2_provider/app/.*\.rb" --html'
      end
    end
    task :coverage => ['db:migrate', 'db:test:prepare', "test:coverage:#{target}"]
  end
  
end
