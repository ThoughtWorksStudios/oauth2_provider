# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)


namespace :oauth do
  
  desc "run all unit tests"
  task :units => [:units_with_ar, :units_with_in_memory_ds]

  desc "run all controller tests"
  task :functionals  => [:functionals_with_ar, :functionals_with_in_memory_ds]

  desc "run all tests"
  task :test => [:units, :functionals]
  
  task :units_with_ar do 
    ENV['OAUTH2_PROVIDER_DATASOURCE'] = 'Oauth2::Provider::ARDatasource'
    Rake::Task["test:units"].execute
  end
  
  task :units_with_in_memory_ds do
    ENV['OAUTH2_PROVIDER_DATASOURCE'] =  'Oauth2::Provider::InMemoryDatasource'
    Rake::Task["test:units"].execute
  end
  
  task :functionals_with_ar do 
    ENV['OAUTH2_PROVIDER_DATASOURCE'] = 'Oauth2::Provider::ARDatasource'
    Rake::Task["test:functionals"].execute
  end
  
  task :functionals_with_in_memory_ds do
    ENV['OAUTH2_PROVIDER_DATASOURCE'] =  'Oauth2::Provider::InMemoryDatasource'
    Rake::Task["test:functionals"].execute
  end
  
end