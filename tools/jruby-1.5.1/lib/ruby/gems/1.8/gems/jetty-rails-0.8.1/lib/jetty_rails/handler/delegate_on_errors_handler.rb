module JettyRails
  module Handler
    
    class DelegateOnErrorsResponse
      include Java::JavaxServletHttp::HttpServletResponse
      
      def initialize(original, request)
        @original = original
        @request = request
      end
      
      def sendError(status_code)
        @request.handled = false
      end
      
      def method_missing(method, *args, &blk)
        @original.send(method, *args, &blk)
      end
    end
    
    class DelegateOnErrorsHandler < Jetty::Handler::HandlerWrapper
      def handle(target, request, response, dispatch)
        decorated_response = DelegateOnErrorsResponse.new(response, request)
        self.handler.handle(target, request, decorated_response, dispatch)
      end
    end
    
  end
end