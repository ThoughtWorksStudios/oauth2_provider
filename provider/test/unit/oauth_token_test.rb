require 'test_helper'

class OauthTokenTest < ActiveSupport::TestCase
  
  def setup
    Clock.fake_now = Time.utc(2008, 1, 20, 0, 0, 1)
  end
  
  def teardown
    Clock.reset
  end
  
  def test_generate_access_token
    token = OauthToken.create!
    token.generate_access_token!
    assert_not_nil token.access_token
    assert_nil token.authorization_code
  end
  
  def test_token_expiry_time_is_one_hour
    token = OauthToken.create!
    assert_equal 1.hour, token.expires_in
  end
  
  def test_token_expires_in_1_hour
    token = OauthToken.create!
    Clock.fake_now = Clock.now + 1.hour
    assert_equal 0, token.expires_in
    assert token.expired?
  end
  
end
