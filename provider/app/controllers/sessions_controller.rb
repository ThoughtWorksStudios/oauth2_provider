class SessionsController < ApplicationController
  
  def index
  end
  
  def create
    if user = User.authenticate(params[:email], params[:password])
      self.current_user = user
      flash[:notice] = 'Welcome!'
      redirect_to '/'
    else
      flash.now[:error] =  "Couldn't locate a user with those credentials"
      render :action => :index
    end
  end
end
