
module JettyRails
  module Handler
    class PublicDirectoryHandler < JettyRails::Handler::DelegateOnErrorsHandler
  
      def initialize(config)
        super()
        @config = config
        @resources = Jetty::Handler::ResourceHandler.new
        @resources.resource_base = @config[:base] + '/public'
        context_capable = add_context_capability_to @resources
        self.handler = context_capable
      end
  
      def add_context_capability_to(handler)
        return handler if @config[:context_path].root?
        context_handler = Jetty::Handler::ContextHandler.new(@config[:context_path])
        context_handler.handler = handler
        context_handler
      end
      
    end
  end
end
