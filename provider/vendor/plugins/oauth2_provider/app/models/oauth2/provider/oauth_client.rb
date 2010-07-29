# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
    
    class ARDatasource
      def find_oauth_client_by_id(id)
        OauthClientDto.find_by_id(id)
      end
      
      def save_oauth_client(attrs)
        client = OauthClientDto.find_by_id(attrs[:id])
        if client
          client.update_attributes(attrs)
        else
          client = OauthClientDto.create(attrs)
        end
        client
      end
      
      def find_oauth_client_by_client_id(client_id)
        OauthClientDto.find_by_client_id(client_id)
      end
      
      def find_all_oauth_client
        OauthClientDto.all
      end
      
      def delete_oauth_client(id)
        OauthClientDto.delete(id)
      end
    end
    
    class OauthClientDto < ActiveRecord::Base
      set_table_name :oauth_clients
    end
    
    class NotFoundException < StandardError
    end
    
    class RecordNotSaved < StandardError
    end
    
    class ModelBase
      include Validatable
      @@db_columns = []
      
      def self.columns(*names)
        attr_accessor *names
        @@db_columns += names
      end
      
      columns :id
      
      def initialize(attributes={})
        assign_attributes(attributes)
      end
      
      @@datasource = ARDatasource.new
      def self.datasource
        @@datasource
      end
          
      def self.find(id)
        find_by_id(id) || raise(NotFoundException.new("Record not found!"))
      end
      
      def self.find_by_id(id)
        if dto = @@datasource.send("find_#{compact_name}_by_id", id) 
          self.new.update_from_dto(dto)
        end
      end
      
      def self.all
        dtos = @@datasource.send("find_all_#{compact_name}")
        dtos.collect do |dto|
          self.new.update_from_dto(dto)
        end
      end
      
      def self.count
        all.size
      end
      
      def self.size
        all.size
      end
      
      def self.compact_name
        self.name.split('::').last.underscore
      end
      
      def self.create(attributes={})
        client = self.new(attributes)
        client.before_create
        client.save
        client
      end
      
      def self.create!(attributes={})
        client = self.new(attributes)
        client.before_create
        client.save!
        client
      end
      
      def save!
        save || raise(RecordNotSaved.new("Could not save model!"))
      end
      
      def update_attributes(attributes={})
        assign_attributes(attributes)
        save
      end
      
      def save
        attrs = @@db_columns.inject({}) do |result, column_name|
          result[column_name] = self.send(column_name)
          result
        end
        if self.valid?
          dto = @@datasource.send("save_#{self.class.compact_name}", attrs)
          update_from_dto(dto)
          return true
        end
        false
      end
      
      def reload
        update_from_dto(self.class.find(id))
      end
      
      def destroy
        before_destroy
        @@datasource.send("delete_#{self.class.compact_name}", id)
      end
      
      def update_from_dto(dto)
        @@db_columns.each do |column_name|
          self.send("#{column_name}=", dto.send(column_name))
        end
        
        self
      end
      
      def assign_attributes(attrs={})
        attrs.each do |k, v|
          self.send("#{k}=", v)
        end
      end


      def before_create
        # for subclasses to override to support hooks.
      end    
      
      def before_destroy
        # for subclasses to override to support hooks.
      end    
      
    end
    
    class OauthClient < ModelBase
      
      validates_presence_of :name, :redirect_uri
      validates_format_of :redirect_uri, :with => Regexp.new("^(https|http)://.+$")
      
      # has_many :oauth_tokens, :class_name => "Oauth2::Provider::OauthToken", :dependent => :delete_all
      # has_many :oauth_authorizations, :class_name => "Oauth2::Provider::OauthAuthorization", :dependent => :delete_all
      

      columns :name, :client_id, :client_secret, :redirect_uri

      def create_token_for_user_id(user_id)
        OauthToken.create!(:user_id => user_id, :oauth_client_id => id)
      end
      
      def create_authorization_for_user_id(user_id)
        OauthAuthorization.create!(:user_id => user_id, :oauth_client_id => id)
      end
      
      def self.find_by_client_id(client_id)
        if dto = @@datasource.find_oauth_client_by_client_id(client_id)
          new.update_from_dto(dto)
        end
      end
      
      def self.model_name
        ActiveSupport::ModelName.new('OauthClient')
      end

      def oauth_tokens
        OauthToken.find_all_by_oauth_client_id(id)
      end
      
      def oauth_authorizations
        OauthAuthorization.find_all_by_oauth_client_id(id)
      end
      
      def before_create
        self.client_id = ActiveSupport::SecureRandom.hex(32)
        self.client_secret = ActiveSupport::SecureRandom.hex(32)
      end
      
      def before_destroy
        oauth_tokens.each(&:destroy)
        oauth_authorizations.each(&:destroy)
      end
    
    end
  end
end