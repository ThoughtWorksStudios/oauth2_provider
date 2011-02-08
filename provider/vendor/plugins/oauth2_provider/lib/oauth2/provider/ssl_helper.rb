# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    module SslHelper

      def self.included(controller_class)
        controller_class.before_filter :mandatory_ssl
      end

      protected
      def mandatory_ssl
        if !request.ssl?
          if !ssl_enabled?
            error = 'This page can only be accessed using HTTPS.'
            flash.now[:error] = error
            render(:text => '', :layout => true, :status => :forbidden)
            return false
          else
            redirect_to params.merge(ssl_base_url_as_url_options)
            return false
          end
        end
        true
      end

      private

      def ssl_base_url_as_url_options
        Oauth2::Provider::Configuration.ssl_base_url_as_url_options
      end

      def ssl_base_url
        Oauth2::Provider::Configuration.ssl_base_url
      end

      def ssl_enabled?
        !ssl_base_url.blank? && ssl_base_url_as_url_options[:protocol] == 'https'
      end
    end
  end
end
