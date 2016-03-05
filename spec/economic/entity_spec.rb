require "./spec/spec_helper"

class Account < Economic::Entity
  has_properties :id, :foo, :baz, :bar_handle

  def build_soap_data
    {:foo => "bar"}
  end

  def existing_method; end

  def proxy
    Economic::AccountProxy.new(session)
  end
end

class Economic::AccountProxy < Economic::EntityProxy; end

describe Economic::Entity do
  let(:session) { make_session }

  describe "class methods" do
    subject { Account }

    describe "new" do
      subject { Economic::Entity.new }

      it "creates a new instance" do
        expect(subject).to be_instance_of(Economic::Entity)
      end

      it "sets persisted to false" do
        expect(subject).to_not be_persisted
      end

      it "sets partial to true" do
        expect(subject).to be_partial
      end

      it "initializes the entity with values from the given hash" do
        entity = Account.new(:foo => "bar", :baz => "qux")
        expect(entity.foo).to eq("bar")
        expect(entity.baz).to eq("qux")
      end
    end

    describe "properties_not_triggering_full_load" do
      it "returns names of special id'ish properties" do
        expect(subject.properties_not_triggering_full_load).to eq([:id, :number, :handle])
      end
    end

    describe "has_properties" do
      it "creates getter for all properties" do
        expect(subject).to receive(:define_method).with("name")
        expect(subject).to receive(:define_method).with("age")
        subject.has_properties :name, :age
      end

      it "creates setter for all properties" do
        expect(subject).to receive(:attr_writer).with(:name)
        expect(subject).to receive(:attr_writer).with(:age)
        subject.has_properties :name, :age
      end

      describe "setter for handles" do
        subject { Account.new }

        it "accepts a Handle" do
          subject.bar_handle = Economic::Entity::Handle.new(:id => 2)
          expect(subject.bar_handle.id).to eq(2)
        end

        it "converts Hash input to Handle" do
          subject.bar_handle = {:id => 1}
          expect(subject.bar_handle).to eq(Economic::Entity::Handle.new(:id => 1))
        end
      end

      it "does not create setter or getter for id'ish properties" do
        expect(subject).to receive(:define_method).with("id").never
        expect(subject).to receive(:define_method).with("number").never
        expect(subject).to receive(:define_method).with("handle").never
        subject.has_properties :id, :number, :handle
      end

      it "does clobber existing methods" do
        expect(subject).to receive(:define_method).with("existing_method")
        subject.has_properties :existing_method
      end

      describe "properties created with has_properties" do
      end
    end
  end

  describe "get_data" do
    subject { Account.new.tap { |e| e.session = session } }

    before :each do
    end

    it "fetches data from API" do
      subject.instance_variable_set("@number", 42)
      mock_request(:account_get_data, {"entityHandle" => {"Number" => 42}}, :success)
      subject.get_data
    end

    it "updates the entity with the response" do
      stub_request(:account_get_data, nil, :success)
      expect(subject).to receive(:update_properties).with(:foo => "bar", :baz => "qux")
      subject.get_data
    end

    it "sets partial to false" do
      stub_request(:account_get_data, nil, :success)
      subject.get_data
      expect(subject).to_not be_partial
    end

    it "sets persisted to true" do
      stub_request(:account_get_data, nil, :success)
      subject.get_data
      expect(subject).to be_persisted
    end
  end

  describe "save" do
    subject { Account.new.tap { |e| e.session = session } }

    context "entity has not been persisted" do
      before :each do
        allow(subject).to receive(:persisted?).and_return(false)
      end

      it "creates the entity" do
        expect(subject).to receive(:create)
        subject.save
      end
    end

    context "entity has already been persisted" do
      before :each do
        allow(subject).to receive(:persisted?).and_return(true)
      end

      it "updates the entity" do
        expect(subject).to receive(:update)
        subject.save
      end
    end
  end

  describe "create" do
    subject { Account.new.tap { |e| e.persisted = false; e.session = session } }

    it "sends data to the API" do
      mock_request(:account_create_from_data, {"data" => {:foo => "bar"}}, :success)
      subject.save
    end

    it "updates handle with the number returned from API" do
      stub_request(:account_create_from_data, :any, :success)
      subject.save
      expect(subject.number).to eq("42")
    end
  end

  describe ".proxy" do
    subject { Account.new.tap { |e| e.session = session } }

    it "should return AccountProxy" do
      expect(subject.proxy).to be_instance_of(Economic::AccountProxy)
    end
  end

  describe "update" do
    subject { Account.new.tap { |e| e.persisted = true; e.session = session } }

    it "sends data to the API" do
      mock_request(:account_update_from_data, {"data" => {:foo => "bar"}}, :success)
      subject.save
    end
  end

  describe "destroy" do
    subject { Account.new.tap { |e| e.id = 42; e.persisted = true; e.partial = false; e.session = session } }

    it "sends data to the API" do
      mock_request(:account_delete, :any, :success)
      subject.destroy
    end

    it "should request with the correct model and id" do
      mock_request(:account_delete, {"accountHandle" => {"Id" => 42}}, :success)
      subject.destroy
    end

    it "should mark the entity as not persisted and partial" do
      mock_request(:account_delete, :any, :success)
      subject.destroy
      expect(subject).to_not be_persisted
      expect(subject).to be_partial
    end

    it "should return the response" do
      expect(session).to receive(:request).and_return(:response => true)
      expect(subject.destroy).to eq(:response => true)
    end
  end

  describe "update_properties" do
    subject { Account.new }

    it "sets the properties to the given values" do
      subject.class.has_properties :foo, :baz
      expect(subject).to receive(:foo=).with("bar")
      expect(subject).to receive(:baz=).with("qux")
      subject.update_properties(:foo => "bar", "baz" => "qux")
    end

    it "only sets known properties" do
      subject.class.has_properties :foo, :bar
      expect(subject).to receive(:foo=).with("bar")
      subject.update_properties(:foo => "bar", "baz" => "qux")
    end
  end

  describe "equality" do
    subject { Account.new }
    let(:other) { Account.new }

    context "when other is nil do" do
      it { is_expected.not_to eq(nil) }
    end

    context "when both handles are empty" do
      it "returns false" do
        subject.handle = Economic::Entity::Handle.new({})
        other.handle = Economic::Entity::Handle.new({})

        expect(subject).not_to eq(other)
      end
    end

    context "when self handle isn't present" do
      it "returns false" do
        subject.handle = nil
        expect(subject).not_to eq(other)
      end
    end

    context "when other handle isn't present" do
      it "returns false" do
        other.handle = nil
        expect(subject).not_to eq(other)
      end
    end

    context "when other handle is equal" do
      let(:handle) { Economic::Entity::Handle.new(:id => 42) }
      subject { Economic::Debtor.new(:handle => handle) }

      context "when other is another class" do
        it "should return false" do
          other = Economic::CashBook.new(:handle => handle)
          expect(subject).not_to eq(other)
        end
      end

      context "when other is same class" do
        it "should return true" do
          other = Economic::Debtor.new(:handle => handle)
          expect(subject).to eq(other)
        end
      end

      context "when other is child class" do
        it "should return true" do
          one = Economic::Entity.new(:handle => handle)
          other = Account.new(:handle => handle)
          expect(one).to eq(other)
        end
      end
    end
  end
end
