require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

class OauthClientsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oauth_clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oauth_client" do
    assert_difference('OauthClient.count') do
      post :create, :oauth_client => { :name => 'foobar', :redirect_uri => 'http://foobar/oauth_callback' }
    end

    assert_redirected_to oauth_client_path(assigns(:oauth_client))
  end

  test "should show oauth_client" do
    get :show, :id => oauth_clients(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => oauth_clients(:one).to_param
    assert_response :success
  end

  test "should update oauth_client" do
    put :update, :id => oauth_clients(:one).to_param, :oauth_client => { }
    assert_redirected_to oauth_client_path(assigns(:oauth_client))
  end

  test "should destroy oauth_client" do
    assert_difference('OauthClient.count', -1) do
      delete :destroy, :id => oauth_clients(:one).to_param
    end

    assert_redirected_to oauth_clients_path
  end
end
