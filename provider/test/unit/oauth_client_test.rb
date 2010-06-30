require File.join(File.expand_path(File.dirname(__FILE__)), '/../test_helper')

class OauthClientTest < ActiveSupport::TestCase
  test "should generate client_id and client_secret for new clients" do
    client = OauthClient.create!(:name => 'foobar')
    assert_not_nil client.client_id
    assert_not_nil client.client_secret
  end
end
