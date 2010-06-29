module OauthProviderHelper
  private
  def client_id
    params[:client_id]
  end
  
  def redirect_uri
    params[:redirect_uri]
  end
end