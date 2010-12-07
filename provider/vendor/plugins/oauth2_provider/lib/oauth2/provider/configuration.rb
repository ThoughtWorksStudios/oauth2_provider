# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    module Configuration
      @@__ssl_port = nil
      module_function
      def ssl_port
        (@@__ssl_port.respond_to?(:call) ? @@__ssl_port.call : @@__ssl_port) || ENV['OAUTH_SSL_PORT']
      end

      def ssl_port=(url_or_proc)
        @@__ssl_port = url_or_proc
      end
    end
  end
end
