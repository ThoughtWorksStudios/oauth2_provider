# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require File.join(File.dirname(__FILE__), '../../../test_helper')
require 'ostruct'

module Oauth2
  module Provider
    class ApplicationControllerMethodsTest < ActiveSupport::TestCase

      def setup
        Clock.fake_now = Time.utc(2008, 1, 20, 1, 2, 3)
        @fooControllerClass = Class.new(ApplicationController)
        @fooControllerClass.send :include, ApplicationControllerMethods

        @controller = @fooControllerClass.new
      end

      def teardown
        Clock.reset
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
      
      def test_subclass_of_a_controller_inherit_oauth_settings
        @fooControllerClass.oauth_allowed({})
        barControllerClass = Class.new(@fooControllerClass)
        assert @controller.send(:oauth_allowed?)
        assert barControllerClass.new.send(:oauth_allowed?)
      end
      
      def test_subclass_of_a_controller_can_override_oauth_settings
        @fooControllerClass.oauth_allowed() { false }
        barControllerClass = Class.new(@fooControllerClass)
        barControllerClass.oauth_allowed() { true }
        
        assert !@fooControllerClass.new.send(:oauth_allowed?)
        assert barControllerClass.new.send(:oauth_allowed?)
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

      def test_user_id_for_oauth_access_token_returns_user_id_when_oauth_allowed_and_block_not_provided
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}}, :ssl? => true)

        @fooControllerClass.oauth_allowed

        assert_equal "17", @controller.send(:user_id_for_oauth_access_token).to_s
      end

      def test_oauth_allowed_when_block_provided_that_returns_true
        @fooControllerClass.oauth_allowed {|controller| true}
        assert @controller.send(:oauth_allowed?)
      end

      def test_oauth_not_allowed_when_block_provided_that_returns_false
        @fooControllerClass.oauth_allowed {|controller| false}
        assert !@controller.send(:oauth_allowed?)
      end

      def test_oauth_not_allowed_when_block_provided_that_returns_true_but_action_is_not_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})

        def @controller.action_name
          "oauth_not_allowed"
        end

        @fooControllerClass.oauth_allowed :only => :oauth_action do |controller|
          true
        end

        assert !@controller.send(:oauth_allowed?)
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end


      def test_oauth_allowed_when_block_provided_that_returns_true_but_action_is_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}}, :ssl? => true)

        def @controller.action_name
          "oauth_action"
        end

        @fooControllerClass.oauth_allowed :only => :oauth_action do |controller|
          true
        end

        assert @controller.send(:oauth_allowed?)
        assert_equal "17", @controller.send(:user_id_for_oauth_access_token).to_s
      end

      def test_oauth_not_allowed_when_block_provided_that_returns_false_but_action_is_not_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})

        def @controller.action_name
          "oauth_not_allowed"
        end

        @fooControllerClass.oauth_allowed :only => :oauth_action do |controller|
          false
        end

        assert !@controller.send(:oauth_allowed?)
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
      end

      def test_oauth_allowed_when_block_provided_that_returns_false_but_action_is_allowed
        @token = OauthToken.create!(:user_id => 17)
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})

        def @controller.action_name
          "oauth_action"
        end

        @fooControllerClass.oauth_allowed :only => :oauth_action do |controller|
          false
        end

        assert !@controller.send(:oauth_allowed?)
        assert_equal nil, @controller.send(:user_id_for_oauth_access_token)
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

        assert_raise_with_message(HttpsRequired, "HTTPS is required for OAuth Authorizations") do
          @controller.send(:user_id_for_oauth_access_token)
        end
      end

      def test_should_identify_oauth_request_based_on_authorization_header
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="some-token"}}, :ssl? => true)
        assert @controller.send(:looks_like_oauth_request?)

        @controller.request = OpenStruct.new(:headers => {"Authorization" => 'hello world'})
        assert !@controller.send(:looks_like_oauth_request?)
      end

      def test_should_identify_oauth_request_based_on_authorization_header_and_ssl
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="some-token"}}, :ssl? => true)
        assert @controller.send(:looks_like_oauth_request?)

        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="some-token"}}, :ssl? => false)
        assert @controller.send(:looks_like_oauth_request?)

        @controller.request = OpenStruct.new(:headers => {"Authorization" => "foo"}, :ssl? => true)
        assert !@controller.send(:looks_like_oauth_request?)
      end

      def test_user_id_for_oauth_access_token_returns_nil_when_token_is_expired
        @token = OauthToken.create!(:user_id => 17)
        Clock.fake_now = Clock.now + OauthToken::EXPIRY_TIME + 1.second
        @controller.request = OpenStruct.new(:headers => {"Authorization" => %Q{Token token="#{@token.access_token}"}})

        def @controller.action_name
          "an_action"
        end

        @fooControllerClass.oauth_allowed

        assert_raise_with_message(HttpsRequired, "HTTPS is required for OAuth Authorizations") do
          @controller.send(:user_id_for_oauth_access_token)
        end
      end
    end
  end
end
