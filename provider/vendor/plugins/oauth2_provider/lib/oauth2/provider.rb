# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

# module Oauth2
#   module Provider
#     
#     class ActiveRecordDataSource
#       def create_oauth_client(attributes)
#         OauthClient.create(attributes)
#       end
#     end
#     
#     @@data_source = ActiveRecordDataSource.new
#     
#     def self.data_source
#       DataSourceWrapper.new(@@data_source)
#     end
#     
#     def self.data_source=(ds)
#       @@data_source = ds
#     end
#     
#     # class DataSourceWrapper
#     #   def initialize(data_source)
#     #     @data_source = data_source
#     #   end
#     #   
#     #   def create_oauth_client(attributes)
#     #     client = @data_source.create_oauth_client(::Oauth2::Provider::OauthClientBehavior.initial_attributes(attributes))
#     #     client.extend(::Oauth2::Provider::OauthClientBehavior)
#     #     client.validate
#     #     client
#     #   end
#     # end
#     
#     
#     
# 
#     
#   end
# end
# 
# 
