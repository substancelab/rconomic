require 'spec/spec_helper'

class SpecEntity < Economic::Entity
  has_properties :foo, :baz

  def existing_method; end
end

describe Economic::Entity do
  let(:session) { stub_session }

  describe "class methods" do
    subject { SpecEntity }

    describe "new" do
      subject { Economic::Entity.new }

      it "creates a new instance" do
        subject.should be_instance_of(Economic::Entity)
      end

      it "sets persisted to false" do
        subject.should_not be_persisted
      end

      it "sets partial to true" do
        subject.should be_partial
      end

      it "initializes the entity with values from the given hash" do
        entity = SpecEntity.new(:foo => 'bar', :baz => 'qux')
        entity.foo.should == 'bar'
        entity.baz.should == 'qux'
      end
    end

    describe "properties_not_triggering_full_load" do
      it "returns names of special id'ish properties" do
        subject.properties_not_triggering_full_load.should == [:id, :number]
      end
    end

    describe "has_properties" do
      it "creates getter for all properties" do
        subject.expects(:define_method).with('name')
        subject.expects(:define_method).with('age')
        subject.has_properties :name, :age
      end

      it "creates setter for all properties" do
        subject.expects(:attr_writer).with(:name)
        subject.expects(:attr_writer).with(:age)
        subject.has_properties :name, :age
      end

      it "does not create setter or getter for id'ish properties" do
        subject.expects(:define_method).with('id').never
        subject.expects(:define_method).with('number').never
        subject.has_properties :id, :number
      end

      it "does not clobber existing methods" do
        subject.expects(:define_method).with('existing_method').never
        subject.has_properties :existing_method
      end

      describe "properties created with has_properties" do
      end
    end

    describe "soap_action" do
      it "returns the name for the given soap action on this class" do
        subject.soap_action(:get_data).should == 'SpecEntity_GetData'

        class Car < Economic::Entity; end
        Car.soap_action(:start_engine).should == 'Car_StartEngine'
        Car.soap_action('StartEngine').should == 'Car_StartEngine'
      end
    end
  end

  describe "get_data" do
    subject { (e = SpecEntity.new).tap { |e| e.session = session } }

    before :each do
      savon.stubs('SpecEntity_GetData').returns(:success)
    end

    it "fetches data from API" do
      subject.instance_variable_set('@number', 42)
      savon.expects('SpecEntity_GetData').with('entityHandle' => {'Number' => 42}).returns(:success)
      subject.get_data
    end

    it "updates the entity with the response" do
      subject.expects(:update_properties).with({:foo => 'bar', :baz => 'qux'})
      subject.get_data
    end

    it "sets partial to false" do
      subject.get_data
      subject.should_not be_partial
    end

    it "sets persisted to true" do
      subject.get_data
      subject.should be_persisted
    end
  end

  describe "save" do
    subject { (e = SpecEntity.new).tap { |e| e.session = session } }

    context "entity has not been persisted" do
      before :each do
        subject.stubs(:persisted?).returns(false)
      end

      it "creates the entity" do
        subject.expects(:create)
        subject.save
      end
    end

    context "entity has already been persisted" do
      before :each do
        subject.stubs(:persisted?).returns(true)
      end

      it "updates the entity" do
        subject.expects(:update)
        subject.save
      end
    end
  end

  describe "create" do
    subject { (e = SpecEntity.new).tap { |e| e.persisted = false; e.session = session } }

    it "sends data to the API" do
      savon.expects('SpecEntity_CreateFromData').returns(:success)
      subject.save
    end
  end

  describe "update" do
    subject { (e = SpecEntity.new).tap { |e| e.persisted = true; e.session = session } }

    it "sends data to the API" do
      savon.expects('SpecEntity_UpdateFromData').returns(:success)
      subject.save
    end
  end

  describe "update_properties" do
    subject { SpecEntity.new }

    it "sets the properties to the given values" do
      subject.expects(:foo=).with('bar')
      subject.expects(:baz=).with('qux')
      subject.update_properties(:foo => 'bar', 'baz' => 'qux')
    end
  end
end

