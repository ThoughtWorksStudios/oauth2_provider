# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

module Oauth2
  module Provider
    class SslHelperController < ActionController::Base
      include SslHelper

      before_filter :mandatory_ssl, :only => [:a, :b]

      def a
        render :nothing => true
      end

      def b
        render :nothing => true
      end

      def c
        render :nothing => true
      end

      def d
        render :nothing => true
      end

      def rescue_action(e)
        raise e
      end
    end

    class SslRequirementTest < ActionController::TestCase
      def setup
        @controller = SslHelperController.new
        @request    = ActionController::TestRequest.new
        @response   = ActionController::TestResponse.new
      end

      def teardown
        ENV['OAUTH_SSL_PORT'] = nil
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_non_443_port_when_request_is_not_ssl_for_action_a
        @controller.instance_variable_set('@ssl_enabled', true)
        ENV['OAUTH_SSL_PORT'] = '8443'
        assert_not_equal "on", @request.env["HTTPS"]
        get :a
        assert_response :redirect
        assert_equal 'https://test.host:8443/oauth2/provider/ssl_helper/a', @response.headers['Location']
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_non_443_port_when_request_is_not_ssl_for_action_b
        @controller.instance_variable_set('@ssl_enabled', true)
        ENV['OAUTH_SSL_PORT'] = '8443'

        get :b
        assert_response :redirect
        assert_equal 'https://test.host:8443/oauth2/provider/ssl_helper/b', @response.headers['Location']
      end

      def test_accessing_ssl_forced_actions_do_not_redirect_when_request_is_ssl
        @request.env['HTTPS'] = "on"
        get :a
        assert_response :success
        get :b
        assert_response :success
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_default_443_port_when_request_is_not_ssl_for_action_a
        @controller.instance_variable_set('@ssl_enabled', true)
        ENV['OAUTH_SSL_PORT'] = '443'
        assert_not_equal "on", @request.env["HTTPS"]
        get :a
        assert_response :redirect
        assert_equal 'https://test.host/oauth2/provider/ssl_helper/a', @response.headers['Location']
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_default_443_port_when_request_is_not_ssl_for_action_b
        @controller.instance_variable_set('@ssl_enabled', true)
        ENV['OAUTH_SSL_PORT'] = '443'

        get :b
        assert_response :redirect
        assert_equal 'https://test.host/oauth2/provider/ssl_helper/b', @response.headers['Location']
      end

      def test_non_ssl_actions_are_available_without_ssl
        assert_not_equal "on", @request.env["HTTPS"]
        get :d
        assert_response :ok
      end

      def test_non_ssl_actions_are_available_with_ssl
        @request.env['HTTPS'] = "on"
        get :d
        assert_response :ok
      end

      def test_ssl_forced_actions_redirect_to_error_page_when_ssl_is_disabled
        assert_not_equal "on", @request.env["HTTPS"]
        @controller.instance_variable_set('@ssl_enabled', false)
        assert !@controller.send(:ssl_enabled?)
        get :a
        assert_response :forbidden
      end

    end
  end
end

