module OAuth2
  module Provider
    class OAuthClientsController < ApplicationController
      def index
        @oauth_clients = OAuthClient.all
      end

      def show
        @oauth_client = OAuthClient.find(params[:id])
      end

      def new
        @oauth_client = OAuthClient.new
      end

      def edit
        @oauth_client = OAuthClient.find(params[:id])
      end

      def create
        @oauth_client = OAuthClient.new(params[:o_auth_client])
        
        if @oauth_client.save
          flash[:notice] = 'OAuthClient was successfully created.'
          redirect_to(@oauth_client)
        else
          render :action => "new" 
        end
      end

      def update
        @oauth_client = OAuthClient.find(params[:id])

        if @oauth_client.update_attributes(params[:o_auth_client])
          flash[:notice] = 'OAuthClient was successfully updated.'
          redirect_to(@oauth_client)
        else
          render :action => "edit"
        end
      end

      def destroy
        @oauth_client = OAuthClient.find(params[:id])
        @oauth_client.destroy

        redirect_to(o_auth_clients_url)
      end
    end
  end
end
