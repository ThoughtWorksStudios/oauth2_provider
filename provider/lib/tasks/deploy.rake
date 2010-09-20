# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

namespace :deploy do
  
  desc "deploy to mingle"
  task :mingle => ['release:gem'] do
    mingle_home = ENV['MINGLE_HOME']

    raise 'Please define MINGLE_HOME to deploy to mingle' unless mingle_home
    
    # the plugin
    rm_rf File.join(mingle_home, 'vendor', 'plugins', 'oauth2_provider'), :verbose => true
    
    `cd #{mingle_home}/vendor/plugins && gem unpack $OLDPWD/pkg/*.gem && mv oauth2_provider-* oauth2_provider`
    
    # copy over the plugin
    cp_r File.expand_path("#{Rails.root}/vendor/plugins/oauth2_provider"), File.join(mingle_home, 'vendor', 'plugins'), :verbose => true
    
    puts '*'*80
    puts 'Please ensure that the migrations are copied manually. This script does not copy over any migrations.'
    puts '*'*80
  end
  
end