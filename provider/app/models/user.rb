class User < ActiveRecord::Base
  include SimplestAuth::Model
  authenticate_by :email

end
