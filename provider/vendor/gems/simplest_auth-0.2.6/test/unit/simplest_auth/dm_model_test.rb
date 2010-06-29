require File.dirname(__FILE__) + '/../../test_helper'

DMUser = Class.new

class DMUserTest < Test::Unit::TestCase
  include BCrypt

  context "with DataMapper" do
    setup do
      DMUser.stubs(:active_record?).returns(false)
      DMUser.stubs(:data_mapper?).returns(true)
      DMUser.stubs(:before)
      DMUser.send(:include, SimplestAuth::Model)
    end

    context "the DMUser class" do
      should "redefine authenticate for DM" do
        DMUser.expects(:instance_eval).with(kind_of(String))
        DMUser.authenticate_by :email
      end

      should "have a default authenticate to email" do
        user = mock do |m|
          m.expects(:authentic?).with('password').returns(true)
        end

        DMUser.expects(:first).with(:email => 'joe@schmoe.com').returns(user)
        assert_equal user, DMUser.authenticate('joe@schmoe.com', 'password')
      end
  
      context "with authenticate_by set to username" do
        setup do
          DMUser.authenticate_by :username
        end

        should "find a user with email for authentication" do
          user = mock do |m|
            m.expects(:authentic?).with('password').returns(true)
          end

          DMUser.expects(:first).with(:username => 'joeschmoe').returns(user)
          assert_equal user, DMUser.authenticate('joeschmoe', 'password')
        end
      end
    end
  end
end
