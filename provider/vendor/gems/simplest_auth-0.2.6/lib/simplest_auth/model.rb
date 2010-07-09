module SimplestAuth
  module Model
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def active_record?
        defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
      end

      def data_mapper?
        defined?(DataMapper) && ancestors.include?(DataMapper::Resource)
      end

      def mongo_mapper?
        defined?(MongoMapper) && ancestors.include?(MongoMapper::Document)
      end

      def authenticate(email, password)
        if active_record?
          klass = find_by_email(email)
        elsif data_mapper? || mongo_mapper?
          klass = first(:email => email)
        end

        (klass && klass.authentic?(password)) ? klass : nil
      end

      def authenticate_by(ident)
        if active_record?
          instance_eval <<-EOM
            def authenticate(#{ident}, password)
              klass = find_by_#{ident}(#{ident})
              (klass && klass.authentic?(password)) ? klass : nil
            end
          EOM
        elsif data_mapper? || mongo_mapper?
          instance_eval <<-EOM
            def authenticate(#{ident}, password)
              klass = first(:#{ident} => #{ident})
              (klass && klass.authentic?(password)) ? klass : nil
            end
          EOM
        end
      end

      def session_key
        if name.to_s.respond_to?(:underscore)
          "#{name.underscore}_id".to_sym
        else
          "#{name.downcase}_id".to_sym
        end
      end
    end

    module InstanceMethods
      RecordNotFound = Class.new(StandardError) unless defined?(RecordNotFound)

      def authentic?(password)
        self.password == password
      end

      private
      def hash_password
        self.password if password_required?
      end

      def password_required?
        self.password.blank? || !self.password.blank?
      end
    end
  end
end