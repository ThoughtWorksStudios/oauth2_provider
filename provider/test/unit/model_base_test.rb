# Copyright (c) 2010 ThoughtWorks Inc. (http://thoughtworks.com)
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require File.join(File.dirname(__FILE__), '../test_helper')

module Oauth2
  module Provider
    class ModelBaseTest < ActiveSupport::TestCase
      
      class TestDatasource

        class MyStruct < OpenStruct

          attr_accessor :id, :attrs
          def initialize(id, attrs)
            self.id = id
            @attrs = attrs
            super(attrs)
          end
        end
                
        def initialize
          @people = {}
          @id = 0
        end
        
        def find_person_by_id(id)
          @people[id]
        end
        
        def find_person_by_name(name)
          @people.values.find {|p| p.name == name }
        end
        
        def find_all_person_by_name(name)
          @people.values.select { |p| p.name == name }
        end
        
        def find_all_person_by_age(age)
          @people.values.select { |p| p.age == age }
        end
        
        
        def find_person_by_age(age)
          @people.values.find {|p| p.age == age }
        end
        
        def find_all_person
          @people.values
        end
        
        def delete_person(id)
          @people.delete(id)
        end
        
        def save_person(attrs)
          person = @people[attrs[:id]]
          if person
            @people[attrs[:id]] = MyStruct.new(attrs[:id], person.attrs.merge(attrs))
            return person
          else
            id = next_id
            @people[id] = MyStruct.new(id, attrs.merge(:id => id))
            return @people[id]
          end
        end
        
        private
        def next_id
          @id += 1
          @id
        end
      end
      
      def setup
        @ds = TestDatasource.new
        @old_ds = ModelBase.datasource
        ModelBase.datasource = @ds
      end
      
      def teardown
        ModelBase.datasource = @old_ds
      end
      
      class Person < ModelBase
        
        attr_accessor :before_create_called, :before_destroy_called
        
        columns :name, :age => :integer
        
        validates_presence_of :name
        validates_presence_of :age
        
        validates_uniqueness_of :name
        
        def before_create
          @before_create_called = true
        end
        
        def before_destroy
          @before_destroy_called = true
        end
        
        def reset
          @before_destroy_called = false
          @before_create_called = false
        end
        
      end
      
      def test_can_create_a_model_return_model_with_id
        john = Person.create(:name => 'John Smith', :age => 29)
        assert_not_nil john.id
        assert_equal "John Smith", john.name
        assert_equal 29, john.age
        assert_equal Person, john.class
      end
      
      def test_find_by_id_should_find_a_model_by_id_if_it_exists
        john = Person.create(:name => 'John Smith', :age => 29)
        person = Person.find_by_id(john.id)
        assert_equal john.id, person.id
        assert_equal Person, person.class
      end
      
      def test_find_by_id_returns_nothing_if_id_does_not_exist
        john = Person.create(:name => 'John Smith', :age => 29)
        assert_nil Person.find_by_id('does not exist')
      end
      
      def test_find_should_find_a_model_by_id_if_it_exists
        john = Person.create(:name => 'John Smith', :age => 29)
        person = Person.find(john.id)
        assert_equal john.id, person.id
        assert_equal Person, person.class
      end
      
      
      def test_find_should_throw_error_if_model_with_id_does_not_exist
        john = Person.create(:name => 'John Smith', :age => 29)
        assert_raise_with_message(NotFoundException, "Record not found!") {Person.find('does not exist')}
      end
      
      def test_should_return_all_model_instances
        john = Person.create(:name => 'John Smith', :age => 29)
        joe = Person.create(:name => 'Joe', :age => 45)
        
        assert_equal [john.id, joe.id].sort, Person.all.collect(&:id).sort
        assert_equal [Person], Person.all.collect(&:class).uniq
      end
      
      def test_should_count_all_model_instances
        Person.create(:name => 'John Smith', :age => 29)
        Person.create(:name => 'Joe', :age => 45)
        
        assert_equal 2, Person.size
        assert_equal 2, Person.count
      end
      
      def test_should_raise_error_on_save_bang_if_invalid
        person = Person.new
        assert_raise_with_message(RecordNotSaved, 'Could not save model!'){person.save!}
      end
      
      def test_should_raise_error_on_create_bang_if_invalid
        assert_raise_with_message(RecordNotSaved, 'Could not save model!'){Person.create!()}
      end
      
      def test_should_not_save_if_invalid
        person = Person.new
        assert !person.save
        assert_equal 0, Person.size
      end
      
      def test_should_not_create_if_invalid
        person = Person.create
        assert_equal 0, Person.size
      end
      
      def test_reload_should_fetch_from_datasource
        john = Person.create(:name => 'John Smith', :age => 29)
        john.age = 45
        john.name = 'joe'

        assert_equal 'joe', john.name
        assert_equal 45, john.age
        
        john.reload
        
        assert_equal 'John Smith', john.name
        assert_equal 29, john.age
      end
      
      def test_destroy_should_remove_from_datasource
        john = Person.create(:name => 'John Smith', :age => 29)
        john.destroy
        
        assert_equal 0, Person.size
      end
      
      def test_should_call_before_create_method_on_model_creation
        john = Person.create(:name => 'John Smith', :age => 29)
        assert john.before_create_called
      end
      
      def test_should_call_before_destroy_method_on_model_deletion
        john = Person.create(:name => 'John Smith', :age => 29)
        john.destroy
        assert john.before_destroy_called
      end
      
      def test_update_attributes_should_save_to_datasource
        person = Person.create(:name => 'John Smith', :age => 29)
        assert person.update_attributes(:name => 'joe', :age => 45)
        joe = Person.find(person.id)
        assert_equal joe.id, person.id
        assert_equal 'joe', joe.name
        assert_equal 45, joe.age
      end
      
      def test_update_attribute_return_false_if_model_is_invalid
        person = Person.create(:name => 'John Smith', :age => 29)
        assert !person.update_attributes(:name => nil, :age => 45)
        assert_equal "John Smith", person.reload.name
      end
      
      def test_update_attributes_with_partial_attributes
        person = Person.create(:name => 'John Smith', :age => 29)
        assert person.update_attributes(:name => 'joe')
        joe = Person.find(person.id)
        assert_equal joe.id, person.id
        assert_equal 'joe', joe.name
        assert_equal 29, joe.age
      end
      
      def test_find_one_by_attribute
        john = Person.create(:name => 'John Smith', :age => 29)
        jane = Person.create(:name => "Jane", :age => 26)
        joe = Person.create(:name => "Joe", :age => 26)
        assert_equal joe.id, Person.find_one(:name, "Joe").id
        assert_equal john.id, Person.find_one(:age, 29).id
        assert_nil Person.find_one(:age, 109)
      end
      
      def test_find_all_by_attribute
        john = Person.create(:name => 'John Smith', :age => 29)
        jane = Person.create(:name => "Jane", :age => 26)
        joe = Person.create(:name => "Joe", :age => 26)

        assert_equal [joe.id], Person.find_all_with(:name, "Joe").collect(&:id)
        assert_equal [jane.id, joe.id], Person.find_all_with(:age, 26).collect(&:id).sort
        assert_equal [], Person.find_all_with(:age, 109)
      end
      
      def test_auto_type_converting_for_finder
        Person.create(:name => 'John Smith', :age => 29)
        assert_not_nil Person.find_one(:age, '29')
        assert !Person.find_all_with(:age, '29').empty?
      end
      
      def test_auto_type_converting_for_model_attribute_reader
        p = Person.create(:name => 123, :age => '29')
        assert_equal "123", p.name
        assert_equal 29, p.age
      end
      
      def test_auto_type_converting_for_model_not_persisted
        p = Person.new(:name => 123, :age => '29')
        assert_equal "123", p.name
        assert_equal 29, p.age
      end
      
      def test_auto_type_converting_for_destroy
        p = Person.create(:name => 123, :age => '29')
        p.destroy
        assert_equal 0, Person.size
      end
      
      def test_can_use_string_as_column_name
        p = Person.create!("name" => "joe", :age => '29')
        assert_not_nil Person.find_one(:name, "joe")
      end
      
      
      def test_to_param_should_return_id
        person = Person.create!(:name => 'foo', :age => 29)
        assert_equal person.id.to_s, person.to_param
      end
      
      def test_to_param_is_nil_when_record_is_new
        assert_nil Person.new(:name => 'foo', :age => 26).to_param
      end
      
      def test_new_record
        person = Person.new(:name => 'foo', :age => 26)
        assert person.new_record?
        person.save!
        assert !person.new_record?
      end
      
      def test_before_create_hook_should_be_called_when_save_a_new_record
        person = Person.new(:name => 'foo', :age => 26)
        person.save
        assert person.before_create_called
      end
      
      def test_before_create_hook_should_not_be_called_when_save_a_existing_record
        person = Person.create(:name => 'foo', :age => 26)
        person.reset
        person.name = "bar"
        person.save!
        assert !person.before_create_called
      end
      
      def test_should_not_allow_duplicate_column_values_when_creating_a_different_object
        Person.create!(:name => 'foo', :age => 26)
        foo = Person.new(:name => 'foo', :age => 28)
        assert !foo.valid?
      end
      
      def test_should_not_allow_duplicate_column_values_when_saving_an_existing_object_to_have_a_used_value
        bob = Person.create!(:name => 'bob', :age => 26)

        joe = Person.create!(:name => 'joe', :age => 28)
        joe.name = 'bob'
        assert !joe.valid?
      end
      
      def test_should_allow_duplicate_column_values_when_saving_the_same_object
        bob = Person.create!(:name => 'bob', :age => 26)
        bob.age = bob.age+1
        assert bob.valid?
      end
      
      def test_should_be_able_to_save_same_object_twice
        bob = Person.new(:name => 'bob', :age => 26)
        assert bob.save
        assert bob.save
      end
      
      def test_to_xml
        john = Person.create(:name => 'John Smith', :age => 29)
        assert_equal %{<?xml version="1.0" encoding="UTF-8"?>
<person>
  <age type="integer">29</age>
  <id type="integer">1</id>
  <name>John Smith</name>
</person>
}, john.to_xml
      end
    end
  end
end
