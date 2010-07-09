require 'test_helper'
require 'ostruct'

module Oauth2
  module Provider
    class ApplicationControllerMethodsTest < ActiveSupport::TestCase
      
      def setup
        @fooControllerClass = Class.new(ApplicationController)
        @fooControllerClass.send :include, ApplicationControllerMethods
        
        @controller = @fooControllerClass.new
      end
  
      def test_oauth_allowed_should_not_allow_both_only_and_except_options
        assert_raise_with_message Exception, 'options cannot contain both :only and :except' do
          @fooControllerClass.oauth_allowed(:only => :foo, :except => :bar)
        end
      end

      def test_oauth_allowed_predicate_is_false_when_oauth_allowed_never_called
        assert !@controller.send(:oauth_allowed?)
      end
  
      def test_oauth_allowed_predicate_is_true_when_no_options_passed_to_oauth_allowed
        @fooControllerClass.oauth_allowed({})
        assert @controller.send(:oauth_allowed?)
      end
  
      def test_oauth_allowed_predicate_should_restrict_oauth_to_actions_specified_by_only_option
        @fooControllerClass.oauth_allowed :only => [:oauth_ok_action, :another_oauth_ok_action]
        def @controller.action_name 
          'oauth_ok_action'
        end
        assert @controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :only => :oauth_ok_action
        def @controller.action_name 
          'oauth_ok_action'
        end
        assert @controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :only => ['oauth_ok_action']
        def @controller.action_name 
          'oauth_ok_action'
        end
        assert @controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :only => [:oauth_ok_action]
        def @controller.action_name 
          'oauth_not_ok_action'
        end
        assert !@controller.send(:oauth_allowed?)
      end
  
      def test_oauth_allowed_predicate_should_disallow_oauth_for_actions_specified_by_except_option
        @fooControllerClass.oauth_allowed :except => [:oauth_not_ok_action, :another_oauth_not_ok_action]
        def @controller.action_name 
          'oauth_not_ok_action'
        end
        assert !@controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :except => :oauth_not_ok_action
        def @controller.action_name 
          'oauth_not_ok_action'
        end
        assert !@controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :except => ['oauth_not_ok_action']
        def @controller.action_name 
          'oauth_not_ok_action'
        end
        assert !@controller.send(:oauth_allowed?)
    
        @fooControllerClass.oauth_allowed :except => [:oauth_not_ok_action]
        def @controller.action_name 
          'oauth_ok_action'
        end
        assert @controller.send(:oauth_allowed?)
    
      end
  
      def test_user_id_for_oauth_access_token_returns_user_id_when_oauth_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})        

        @fooControllerClass.oauth_allowed
    
        assert_equal "17", @controller.send(:user_id_for_oauth_access_token)
      end
  
      def test_user_id_for_oauth_access_token_returns_nil_when_oauth_not_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})        
        def @controller.action_name
          "an_action"
        end
        @fooControllerClass.oauth_allowed(:only => [])
    
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end
  
      def test_user_id_for_oauth_access_token_returns_nil_when_bogus_token
        @token = OauthToken.create!(:user_id => 17)
        
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="bogus"}})
        def @controller.action_name
          "an_action"
        end
                
        @fooControllerClass.oauth_allowed
    
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end
      
      def test_should_identify_oauth_request_based_on_authorization_header
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="some-token"}})
        assert @controller.send(:looks_like_oauth_request?)
        
        @controller.request = OpenStruct.new(:headers => {"Authorization" => 'hello world'})
        assert !@controller.send(:looks_like_oauth_request?)
      end
    end
  end
end