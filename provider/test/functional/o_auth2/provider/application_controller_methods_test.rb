require 'test_helper'

module OAuth2
  module Provider
    class ApplicationControllerMethodsTest < ActiveSupport::TestCase
  
      def setup
        @fooControllerClass = Class.new
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
        @token = OAuthToken.create!(:user_id => 17)
        @token.generate_access_token!
        @controller.instance_variable_set(:@__token, @token)
        def @controller.params
          {:access_token => @__token.access_token}
        end
        @fooControllerClass.oauth_allowed
    
        assert_equal "17", @controller.send(:user_id_for_oauth_access_token)
      end
  
      def test_user_id_for_oauth_access_token_returns_nil_when_oauth_not_allowed
        @token = OAuthToken.create!(:user_id => 17)
        @token.generate_access_token!
        @controller.instance_variable_set(:@__token, @token)
        def @controller.params
          {:access_token => @__token.access_token}
        end
        def @controller.action_name
          "an_action"
        end
        @fooControllerClass.oauth_allowed(:only => [])
    
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end
  
      def test_user_id_for_oauth_access_token_returns_nil_when_bogus_token
        def @controller.params
          {:access_token => "bogus"}
        end
        def @controller.action_name
          "an_action"
        end
        @fooControllerClass.oauth_allowed
    
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end
    end
  end
end