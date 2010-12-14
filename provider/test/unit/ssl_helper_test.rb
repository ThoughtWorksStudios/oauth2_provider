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

    class SslHelperTest < ActionController::TestCase
      def setup
        @controller = SslHelperController.new
        @request    = ActionController::TestRequest.new
        @response   = ActionController::TestResponse.new
      end

      def teardown
        Oauth2::Provider::Configuration.ssl_base_url = nil
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_non_443_port_when_request_is_not_ssl_for_action_a
        Oauth2::Provider::Configuration.ssl_base_url = 'https://test.host:8443/'
        assert_not_equal "on", @request.env["HTTPS"]
        get :a
        assert_response :redirect
        assert_equal 'https://test.host:8443/oauth2/provider/ssl_helper/a', @response.headers['Location']
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_non_443_port_when_request_is_not_ssl_for_action_b
        Oauth2::Provider::Configuration.ssl_base_url = 'https://test.host:8443/'

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
        Oauth2::Provider::Configuration.ssl_base_url = 'https://test.host:443/'
        assert_not_equal "on", @request.env["HTTPS"]
        get :a
        assert_response :redirect
        assert_equal 'https://test.host/oauth2/provider/ssl_helper/a', @response.headers['Location']
      end

      def test_accessing_ssl_forced_actions_redirect_to_ssl_with_default_443_port_when_request_is_not_ssl_for_action_b
        Oauth2::Provider::Configuration.ssl_base_url = 'https://test.host:443/'
        get :b
        assert_response :redirect
        assert_equal 'https://test.host/oauth2/provider/ssl_helper/b', @response.headers['Location']
      end

      def test_non_ssl_actions_are_available_without_ssl_enabled
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
        Oauth2::Provider::Configuration.ssl_base_url = ''
        get :a
        assert_response :forbidden
      end

      def test_should_throw_error_when_ssl_base_url_is_non_ssl
        Oauth2::Provider::Configuration.ssl_base_url = 'http://non.ssl'
        assert_not_equal "on", @request.env["HTTPS"]
        assert_raise_with_message(RuntimeError, 'SSL base URL must be https') {get :a}
      end
      
      def test_should_forward_to_base_url_when_request_is_on_non_ssl_and_a_different_host_name
        Oauth2::Provider::Configuration.ssl_base_url = 'https://secure.example.com'
        @request.host = 'example.com'
        get :a
        assert_response :redirect
        assert_equal 'https://secure.example.com/oauth2/provider/ssl_helper/a', @response.headers['Location']
      end
    end
  end
end

