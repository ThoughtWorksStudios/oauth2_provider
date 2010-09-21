# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    class OauthClientsController < ApplicationController
      
      def index
        @oauth_clients = OauthClient.all
        respond_to do |format|
          format.html
          format.xml  { render :xml => @oauth_clients.to_xml(:root => 'oauth_clients', :dasherize => false) }
        end
      end

      def show
        @oauth_client = OauthClient.find(params[:id])
        respond_to do |format|
          format.html
          format.xml  { render :xml => @oauth_client.to_xml(:dasherize => false) }
        end
      end

      def new
        @oauth_client = OauthClient.new
      end

      def edit
        @oauth_client = OauthClient.find(params[:id])
      end

      def create
        @oauth_client = OauthClient.new(params[:oauth_client])
        
        respond_to do |format|
          if @oauth_client.save
            flash[:notice] = 'OAuth Client was successfully created.'
            format.html { redirect_to :action => 'index' }
            format.xml  { render :xml => @oauth_client, :status => :created, :location => @oauth_client }
          else
            flash.now[:error] = @oauth_client.errors.full_messages
            format.html { render :action => "new" }
            format.xml  { render :xml => @oauth_client.errors, :status => :unprocessable_entity }
          end
        end
      end

      def update
        @oauth_client = OauthClient.find(params[:id])

        respond_to do |format|
          if @oauth_client.update_attributes(params[:oauth_client])
            flash[:notice] = 'OAuth Client was successfully updated.'
            format.html { redirect_to :action => 'index' }
            format.xml  { head :ok }
          else
            flash.now[:error] = @oauth_client.errors.full_messages
            format.html { render :action => "edit" }
            format.xml  { render :xml => @oauth_client.errors, :status => :unprocessable_entity }
          end
        end

      end

      def destroy
        @oauth_client = OauthClient.find(params[:id])
        @oauth_client.destroy

        respond_to do |format|
          format.html { redirect_to(oauth_clients_url) }
          format.xml  { head :ok }
        end
      end
    end
  end
end
