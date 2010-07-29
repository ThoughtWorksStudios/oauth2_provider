# module Oauth2
#   module Provider
#     module OauthClientBehavior
#       def self.initial_attributes(attributes)
#         attributes.merge(
#           :client_id => ActiveSupport::SecureRandom.hex(32), 
#           :client_secret => ActiveSupport::SecureRandom.hex(32))
#       end
#       
#       def self.validate(attributes)
#         
#       end
#       
#       def initialize
#         @validate_errors = []
#       end
#       
#       def validate
#         @errors << "Redirect_uri can not be blank" if redirect_uri.blank?
#         @errors << "Redirect_uri is invalid" if redirect_uri !~ Regexp.new("^(https|http)://.+$")
#       end
#       
#       
#     end
#   end
# end