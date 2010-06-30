module OauthProviderHelper
  private
  def client_id
    params[:client_id]
  end
  
  def redirect_uri
    params[:redirect_uri]
  end
  
  def client_secret
    params[:client_secret]
  end
  
  def authorization_code
    params[:code]
  end
end