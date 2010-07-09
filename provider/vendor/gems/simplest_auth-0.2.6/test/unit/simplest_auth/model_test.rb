require File.dirname(__FILE__) + '/../../test_helper'

class User; end

class UserTest < Test::Unit::TestCase
  include BCrypt

  context "with no ORM" do
    setup do
      User.stubs(:active_record?).returns(false)
      User.stubs(:data_mapper?).returns(false)
      User.send(:include, SimplestAuth::Model)
    end

    should "return nil for authenticate" do
      assert_equal nil, User.authenticate('email', 'password')
    end
  end

  context "The User class" do
    should "define a session key" do
      assert_equal :user_id, User.session_key
    end
  end

  context "An instance of the User class" do
    setup do
      User.send(:include, SimplestAuth::Model)
      @user = User.new
      @user.stubs(:password).returns('abcdefg')
    end

    should "determine if a password is authentic" do
      password_stub = stub
      password_stub.stubs(:==).with('password').returns(true)
      Password.stubs(:new).with('abcdefg').returns(password_stub)

      assert @user.authentic?('password')
    end

    should "determine when a password is not authentic" do
      password_stub = stub
      password_stub.stubs(:==).with('password').returns(false)
      Password.stubs(:new).with('abcdefg').returns(password_stub)
      
      assert_equal false, @user.authentic?('password')
    end

    should "use the Password class == method for comparison" do
      password_stub = mock
      password_stub.expects(:==).with('password').returns(true)
      Password.stubs(:new).with('abcdefg').returns(password_stub)
      
      @user.authentic?('password')
    end

    should "use a new Password made from password" do
      password_stub = stub
      password_stub.stubs(:==).with('password').returns(true)
      Password.expects(:new).with('abcdefg').returns(password_stub)
      
      @user.authentic?('password')
    end

    should "hash a password using bcrypt" do
      @user.stubs(:password_required?).returns(true)
      @user.expects(:password=).with('abcdefg')
      @user.password = 'password'
      Password.expects(:create).with('password').returns('abcdefg')

      @user.send(:hash_password)
    end

    should "require a password if crypted password is blank" do
      @user.stubs(:password).returns(stub(:blank? => true))
      assert_equal true, @user.send(:password_required?)
    end

    should "require a password if a password has been set" do
      @user.stubs(:password).returns(stub(:blank? => false))
      @user.stubs(:password).returns(stub(:blank? => false))
      assert_equal true, @user.send(:password_required?)
    end
  end
end
