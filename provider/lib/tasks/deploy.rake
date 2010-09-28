# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

namespace :deploy do

  class DeployOAuthPlugin
    def self.deploy(rails_root)
      # the plugin
      rm_rf File.join(rails_root, 'vendor', 'plugins', 'oauth2_provider'), :verbose => true

      `cd #{rails_root}/vendor/plugins && gem unpack $OLDPWD/pkg/*.gem && mv oauth2_provider-* oauth2_provider`

      puts '*'*80
      puts 'Please ensure that the migrations are copied manually. This script does not copy over any migrations.'
      puts '*'*80
    end
  end

  desc "deploy to mingle"
  task :mingle => ['release:gem'] do
    mingle_home = ENV['MINGLE_HOME']
    raise 'Please define MINGLE_HOME to deploy to mingle' unless mingle_home

    DeployOAuthPlugin.deploy(mingle_home)
  end


  desc "deploy to go"
  task :go => ['release:gem'] do
    go_home = ENV['GO_HOME']
    raise 'Please define GO_HOME to deploy to go' unless go_home

    DeployOAuthPlugin.deploy(go_home + '/server/webapp/WEB-INF/rails')
  end

end

