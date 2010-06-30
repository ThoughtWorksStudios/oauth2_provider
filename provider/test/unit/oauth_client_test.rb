require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

class OauthClientTest < ActiveSupport::TestCase
  def should_generate_client_id_and_client_secret_when_creating_clients
    client = OauthClient.create!(:name => 'foobar', :redirect_uri => 'http://example.com/cb')
    assert_not_nil client.client_id
    assert_not_nil client.client_secret
  end
  
  def should_not_allow_creating_clients_without_a_name
    assert_raise_with_message ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank" do
      OauthClient.create!(:redirect_uri => 'http://example.com/cb')
    end
  end
  
  def should_not_allow_creating_clients_without_a_redirct_uri
    assert_raise_with_message ActiveRecord::RecordInvalid, "Validation failed: Redirect uri can't be blank" do
      OauthClient.create!(:name => 'foobar')
    end
  end
end
