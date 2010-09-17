require "jruby"

module JettyRails
  
  class Runner
    attr_reader :servers
    
    def initialize(config = {})
      @servers = {}
      config.symbolize_keys!
      if config[:servers].nil?
        add_server(config) 
      else
        config[:servers].each do |server_config|
          server_config.symbolize_keys!
          server_config.reverse_merge!(config)
          server_config.delete(:servers)
          add_server(server_config)
        end
      end
    end
    
    def add_server(config = {})
      server = JettyRails::Server.new(config)
      @servers[server.config[:port]] = server
    end
    
    def start
      server_threads = ThreadGroup.new
      @servers.each do |base, server|
        log("Starting server #{base}")
        server_threads.add(Thread.new do
          server.start
        end)
      end
      
      server_threads.list.each {|thread| thread.join } unless server_threads.list.empty?
    end
    
    private
    
    def log(msg)
      $stdout.puts(msg)
    end
  end
end
