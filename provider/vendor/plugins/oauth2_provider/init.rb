ApplicationController.send :include, ApplicationControllerMethods

Dir["#{File.expand_path(File.join(File.dirname(__FILE__), 'hooks'))}/*.rb"].each do |hook_file|
  require hook_file
end

