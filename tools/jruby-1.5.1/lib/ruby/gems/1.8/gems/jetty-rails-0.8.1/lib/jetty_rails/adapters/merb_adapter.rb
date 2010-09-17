module JettyRails
  module Adapters
    
    class MerbAdapter < AbstractAdapter
      
      def init_params
        # please refer to goldspike and jruby-rack documentation
        @merb_params ||= {
          'merb.root' => '/',
          'merb.environment' => config[:environment]
        }.merge(base_init_params)
      end
      
      def event_listeners
        [ Rack::MerbServletContextListener.new, SignalHandler.new ]
      end
      
      class SignalHandler
        include Java::JavaxServlet::ServletContextListener
        
        def contextInitialized(cfg)
          trap("INT") do
            puts "\nbye!"
            java.lang.System.exit(0)
          end
        end
        
        def contextDestroyed(cfg)
        end
      end
      
    end
  end
end