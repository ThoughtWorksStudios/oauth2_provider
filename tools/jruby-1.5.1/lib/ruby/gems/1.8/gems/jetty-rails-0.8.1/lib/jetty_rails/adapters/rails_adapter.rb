module JettyRails
  module Adapters
    
    class RailsAdapter < AbstractAdapter
            
      def init_params
        # please refer to goldspike and jruby-rack documentation
        # in: PoolingRackApplicationFactory 
        @rails_params ||= {
          'rails.root' => '/',
          'rails.env' => config[:environment]
        }.merge(base_init_params)
      end
      
      def event_listeners
        [ Rack::RailsServletContextListener.new ]
      end
      
    end
    
  end
end