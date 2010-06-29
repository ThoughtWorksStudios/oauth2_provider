class SessionsController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'create']

  def index
    # renders the login page
  end
  
  def create
    if user = User.authenticate(params[:email], params[:password])
      self.current_user = user
      flash[:notice] = 'Welcome!'
      redirect_to '/'
      return
    else
      flash.now[:error] =  "Couldn't locate a user with those credentials"
      redirect_to :action => :index
    end
  end
  
  def clear_session
    super
    redirect_to :action => :index
  end
end
