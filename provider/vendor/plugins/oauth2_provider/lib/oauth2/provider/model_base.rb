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
      CONVERTORS =  {
        :integer => Proc.new { |v| v.to_i },
        :string  => Proc.new { |v| v.to_s }
      }.with_indifferent_access

      class_inheritable_hash :db_columns
      self.db_columns = {}
      
      class_inheritable_array :unique_columns
      self.unique_columns = []
      
      def self.columns(*names)
        names.each do |name|
          column_name, convertor = (Hash === name) ?
            [name.keys.first, CONVERTORS[name.values.first]] :
            [name, CONVERTORS[:string]]
          attr_accessor column_name
          self.db_columns[column_name.to_s] = convertor
        end
      end

      columns :id => :integer

      def initialize(attributes={})
        assign_attributes(attributes)
      end

      cattr_accessor :datasource

      def self.datasource=(ds)
        @@datasource =  case ds
                        when NilClass
                          default_datasource
                        when String
                          eval(ds).new
                        when Class
                          ds.new
                        else
                          ds
                        end
      end
      
      def self.validates_uniqueness_of(*columns)
        unique_columns << columns
        unique_columns.flatten!.uniq!
      end
      
      def self.datasource
        @@datasource ||= default_datasource
      end

      def datasource
        self.class.datasource
      end

      def self.default_datasource
        if defined?(ActiveRecord)
          ARDatasource.new
        else
          unless ENV['LOAD_OAUTH_SILENTLY']
            puts "*"*80
            puts "*** Activerecord is not defined! Using InMemoryDatasource, which will not persist across application restarts!! ***"
            puts "*"*80
          end
          InMemoryDatasource.new
        end
      end

      def self.find(id)
        find_by_id(id) || raise(NotFoundException.new("Record not found!"))
      end

      def self.find_by_id(id)
        find_one(:id, id)
      end

      def self.find_all_with(column_name, column_value)
        datasource.send("find_all_#{compact_name}_by_#{column_name}", convert(column_name, column_value)).collect do |dto|
          new.update_from_dto(dto)
        end
      end

      def self.find_one(column_name, column_value)
        if dto = datasource.send("find_#{compact_name}_by_#{column_name}", convert(column_name, column_value))
          self.new.update_from_dto(dto)
        end
      end

      def self.all
        datasource.send("find_all_#{compact_name}").collect do |dto|
          new.update_from_dto(dto)
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
        client.save
        client
      end

      def self.create!(attributes={})
        client = self.new(attributes)
        client.save!
        client
      end

      def update_attributes(attributes={})
        assign_attributes(attributes)
        save
      end

      def save!
        save || raise(RecordNotSaved.new("Could not save model!"))
      end

      def save
        before_create if new_record?
        attrs = db_columns.keys.inject({}) do |result, column_name|
          result[column_name] = read_attribute(column_name)
          result
        end

        if self.valid?
          dto = datasource.send("save_#{self.class.compact_name}", attrs.with_indifferent_access)
          update_from_dto(dto)
          return true
        end
        false
      end
      
      def valid?
        duplicate_exists = unique_columns.find do |column_name|
          dto = datasource.send("find_#{self.class.compact_name}_by_#{column_name}", read_attribute(column_name))
          next if dto && dto.id == self.id
          dto
        end
        !duplicate_exists && super
      end
      
      def reload
        update_from_dto(self.class.find(id))
      end

      def destroy
        before_destroy
        datasource.send("delete_#{self.class.compact_name}", convert(:id, id) )
      end

      def before_create
        # for subclasses to override to support hooks.
      end

      def before_destroy
        # for subclasses to override to support hooks.
      end

      def update_from_dto(dto)
        db_columns.keys.each do |column_name|
          write_attribute(column_name, dto.send(column_name))
        end
        self
      end

      def new_record?
        id.nil?
      end

      def to_param
        id.nil? ? nil: id.to_s
      end

      def assign_attributes(attrs={})
        attrs.each { |k, v| write_attribute(k, v) }
      end

      def to_xml(options = {})
        acc = self.db_columns.keys.sort.inject(ActiveSupport::OrderedHash.new) do |acc, key|
          acc[key] = self.send(key)
          acc
        end
        acc.to_xml({:root => self.class.name.demodulize.underscore.downcase}.merge(options))
      end

      private

      def self.convert(column_name, value)
        db_columns[column_name.to_s].call(value)
      end

      def convert(column_name, value)
        self.class.convert(column_name, value)
      end

      def read_attribute(column_name)
        convert(column_name, self.send(column_name))
      end

      def write_attribute(column_name, value)
        self.send("#{column_name}=", convert(column_name, value))
      end

    end
  end
end
