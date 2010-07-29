# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

module Oauth2
  module Provider
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
  end
end
