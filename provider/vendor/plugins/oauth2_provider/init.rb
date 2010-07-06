# Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |r| require r}

ApplicationController.send :include, ::OAuth2::Provider::ApplicationControllerMethods
