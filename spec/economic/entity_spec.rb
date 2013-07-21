require './spec/spec_helper'

class SpecEntity < Economic::Entity
  has_properties :id, :foo, :baz

  def build_soap_data; {}; end
  def existing_method; end

  def proxy; Economic::SpecEntityProxy.new(session); end
end

class Economic::SpecEntityProxy < Economic::EntityProxy; end

describe Economic::Entity do
  let(:session) { make_session }

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
        subject.properties_not_triggering_full_load.should == [:id, :number, :handle]
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
        subject.expects(:define_method).with('handle').never
        subject.has_properties :id, :number, :handle
      end

      it "does clobber existing methods" do
        subject.expects(:define_method).with('existing_method')
        subject.has_properties :existing_method
      end

      describe "properties created with has_properties" do
      end
    end

    describe "soap_action" do
      it "returns the name for the given soap action on this class" do
        subject.soap_action_name(:get_data).should == :spec_entity_get_data

        class Car < Economic::Entity; end
        Car.soap_action_name(:start_engine).should == :car_start_engine
        Car.soap_action_name('StartEngine').should == :car_start_engine
      end
    end
  end

  describe "get_data" do
    subject { (e = SpecEntity.new).tap { |e| e.session = session } }

    before :each do
      savon.stubs(:spec_entity_get_data).returns(:success)
    end

    it "fetches data from API" do
      subject.instance_variable_set('@number', 42)
      savon.expects(:spec_entity_get_data).with('entityHandle' => {'Number' => 42}).returns(:success)
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
      savon.expects(:spec_entity_create_from_data).returns(:success)
      subject.save
    end

    it "updates handle with the number returned from API" do
      savon.expects(:spec_entity_create_from_data).returns(:success)
      subject.save
      subject.number.should == '42'
    end
  end

  describe ".proxy" do
    subject { (e = SpecEntity.new).tap { |e| e.session = session } }

    it "should return SpecEntityProxy" do
      subject.proxy.should be_instance_of(Economic::SpecEntityProxy)
    end
  end

  describe "update" do
    subject { (e = SpecEntity.new).tap { |e| e.persisted = true; e.session = session } }

    it "sends data to the API" do
      savon.expects(:spec_entity_update_from_data).returns(:success)
      subject.save
    end
  end

  describe "destroy" do
    subject { (e = SpecEntity.new).tap { |e| e.id = 42; e.persisted = true; e.partial = false; e.session = session } }

    it "sends data to the API" do
      savon.expects(:spec_entity_delete).returns(:success)
      subject.destroy
    end

    it "should request with the correct model and id" do
      savon.expects(:spec_entity_delete).with('specEntityHandle' => {'Id' => 42}).returns(:success)
      subject.destroy
    end

    it "should mark the entity as not persisted and partial" do
      savon.expects(:spec_entity_delete).returns(:success)
      subject.destroy
      subject.should_not be_persisted
      subject.should be_partial
    end

    it "should return the response" do
      session.expects(:request).returns({ :response => true })
      subject.destroy.should == { :response => true }
    end
  end

  describe "update_properties" do
    subject { SpecEntity.new }

    it "sets the properties to the given values" do
      subject.class.has_properties :foo, :baz
      subject.expects(:foo=).with('bar')
      subject.expects(:baz=).with('qux')
      subject.update_properties(:foo => 'bar', 'baz' => 'qux')
    end

    it "only sets known properties" do
      subject.class.has_properties :foo, :bar
      subject.expects(:foo=).with('bar')
      subject.update_properties(:foo => 'bar', 'baz' => 'qux')
    end
  end

  describe "equality" do
    subject { SpecEntity.new }
    let(:other) { SpecEntity.new }

    context "when other is nil do" do
      it { should_not == nil }
    end

    context "when both handles are empty" do
      it "returns false" do
        subject.handle = Economic::Entity::Handle.new({})
        other.handle = Economic::Entity::Handle.new({})

        subject.should_not == other
      end
    end

    context "when self handle isn't present" do
      it "returns false" do
        subject.handle = nil
        subject.should_not == other
      end
    end

    context "when other handle isn't present" do
      it "returns false" do
        other.handle = nil
        subject.should_not == other
      end
    end

    context "when other handle is equal" do
      let(:handle) { Economic::Entity::Handle.new(:id => 42) }
      subject { Economic::Debtor.new(:handle => handle) }

      context "when other is another class" do
        it "should return false" do
          other = Economic::CashBook.new(:handle => handle)
          subject.should_not == other
        end
      end

      context "when other is same class" do
        it "should return true" do
          other = Economic::Debtor.new(:handle => handle)
          subject.should == other
        end
      end

      context "when other is child class" do
        it "should return true" do
          one = Economic::Entity.new(:handle => handle)
          other = SpecEntity.new(:handle => handle)
          one.should == other
        end
      end
    end
  end
end
