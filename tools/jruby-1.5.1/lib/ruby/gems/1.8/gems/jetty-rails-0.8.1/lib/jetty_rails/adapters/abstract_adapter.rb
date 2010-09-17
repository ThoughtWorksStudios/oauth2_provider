module JettyRails
  module Adapters
    class AbstractAdapter
      attr_reader :config
      
      def initialize(config)
        @config = config
      end
      
      def base_init_params()
        @base_init_params ||= { 
          'public.root' => '/public',
          'gem.path' => config[:gem_path] || ENV['GEM_PATH'] || 'tmp/war/WEB-INF/gems',
          'jruby.initial.runtimes' => "#{config[:jruby_min_runtimes]}",
          'jruby.min.runtimes' => "#{config[:jruby_min_runtimes]}",
          'jruby.max.runtimes' => "#{config[:jruby_max_runtimes]}"
        }
      end
      
      def event_listeners
        []
      end
    end
  end
end
