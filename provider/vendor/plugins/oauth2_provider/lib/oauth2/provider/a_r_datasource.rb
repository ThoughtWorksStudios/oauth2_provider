# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    class ARDatasource
      def find_oauth_client_by_id(id)
        OauthClientDto.find_by_id(id)
      end
  
      def save_oauth_client(attrs)
        client = OauthClientDto.find_by_id(attrs[:id])
        if client
          client.update_attributes(attrs)
        else
          client = OauthClientDto.create(attrs)
        end
        client
      end
  
      def find_oauth_client_by_client_id(client_id)
        OauthClientDto.find_by_client_id(client_id)
      end
  
      def find_all_oauth_client
        OauthClientDto.all
      end
  
      def delete_oauth_client(id)
        OauthClientDto.delete(id)
      end
    end

    class OauthClientDto < ActiveRecord::Base
      set_table_name :oauth_clients
    end

  end
end
