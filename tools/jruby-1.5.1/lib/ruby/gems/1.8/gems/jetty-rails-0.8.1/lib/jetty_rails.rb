jetty_libs_dir = "#{File.dirname(__FILE__)}/../jetty-libs"
$:.unshift(File.expand_path(jetty_libs_dir)) unless
  $:.include?(jetty_libs_dir) || $:.include?(File.expand_path(jetty_libs_dir))

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "java"
require "rubygems"
require "activesupport"
require "jetty_rails/jars"
require "jetty_rails/adapters/abstract_adapter"
require "jetty_rails/adapters/rails_adapter"
require "jetty_rails/adapters/merb_adapter"
require "jetty_rails/runner"
require "jetty_rails/server"
require "jetty_rails/handler/delegate_on_errors_handler"
require "jetty_rails/handler/public_directory_handler"
require "jetty_rails/handler/web_app_handler"
require "jetty_rails/config/command_line_reader"

module JettyRails
  VERSION = '0.8.1'
  JETTY_RAILS_HOME = File.dirname(__FILE__) + "/.." unless defined?(JETTY_RAILS_HOME)
end
