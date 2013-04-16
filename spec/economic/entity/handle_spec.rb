require './spec/spec_helper'

describe Economic::Entity::Handle do
  describe "equality" do
    let(:handle_a) { Economic::Entity::Handle.new(:id => 1, :number => 2) }
    let(:handle_b) { Economic::Entity::Handle.new(:id => 1, :number => 2) }
    let(:handle_c) { Economic::Entity::Handle.new(:id => 1) }
    let(:handle_d) { Economic::Entity::Handle.new(:id => 1, :number => 3) }

    it "should be equal when both id and number are equal" do
      handle_a.should == handle_b
    end

    it "should not be equal when id or number is missing" do
      handle_a.should_not == handle_c
    end

    it "should not be equal when id or number is equal and the other isn't" do
      handle_a.should_not == handle_d
    end

    describe "CashBookEntry handles" do
      let(:handle_a) { Economic::Entity::Handle.new(:id1 => 1, :id2 => 2) }

      context "when id1 and id2 values are equal" do
        let(:handle_b) { Economic::Entity::Handle.new(:id1 => 1, :id2 => 2) }

        it "should be equal" do
          handle_a.should == handle_b
        end
      end

      context "when id1 and id2 values are different" do
        let(:handle_b) { Economic::Entity::Handle.new(:id1 => 11, :id2 => 12) }

        it "should_not be equal" do
          handle_a.should_not == handle_b
        end
      end
    end

  end

  describe ".new" do
    it "should raise error if argument isn't supported" do
      lambda do
        Economic::Entity::Handle.new(true)
      end.should raise_error(ArgumentError)
    end

    it "should assume :id if argument is numeric" do
      handle = Economic::Entity::Handle.new(12)
      handle.id.should == 12
      handle.number.should be_nil
    end

    it "should use to_i on numeric argument" do
      handle = Economic::Entity::Handle.new("42")
      handle.id.should == 42
    end

    it "should raise error if argument is nil" do
      lambda do
        Economic::Entity::Handle.new(nil)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if argument contains invalid key" do
      lambda do
        Economic::Entity::Handle.new(:Numeric => 12)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if argument contains invalid values" do
      lambda do
        Economic::Entity::Handle.new(:number => {:number => 12})
      end.should raise_error(ArgumentError)
    end

    it "should set id" do
      handle = Economic::Entity::Handle.new(:id => 12)
      handle.id.should == 12
    end

    it "should set number" do
      handle = Economic::Entity::Handle.new(:number => 12)
      handle.number.should == 12
    end

    it "should set both id and number" do
      handle = Economic::Entity::Handle.new(:id => 37, :number => 42)
      handle.id.should == 37
      handle.number.should == 42
    end

    it 'should set id1 and id2' do
      handle = Economic::Entity::Handle.new(:id1 => 37, :id2 => 42)
      handle.id1.should == 37
      handle.id2.should == 42
    end

    it "should to_i values" do
      handle = Economic::Entity::Handle.new(:id => "37", :number => "42")
      handle.id.should == 37
      handle.number.should == 42
    end

    it "should not to_i nil values" do
      handle = Economic::Entity::Handle.new(:id => "37")
      handle.id.should == 37
      handle.number.should be_nil
    end

    it "should accept a Hash with capitalized keys" do
      handle = Economic::Entity::Handle.new({"Id" => 37, "Number" => 42})
      handle.id.should == 37
      handle.number.should == 42
    end

    it "should accept another Handle" do
      original_handle = Economic::Entity::Handle.new(:id => 37)
      handle = Economic::Entity::Handle.new(original_handle)
      handle.id.should == 37
      handle.number.should be_nil
      handle.should == original_handle
    end
  end

  describe ".build" do
    it "returns nil when given nil" do
      Economic::Entity::Handle.build(nil).should be_nil
    end

    it "returns nil when hash is empty" do
      Economic::Entity::Handle.build({}).should be_nil
    end

    it "returns nil when hash has no values" do
      Economic::Entity::Handle.build({:id => nil, :number => nil}).should be_nil
    end

    it "returns handle when hash has values" do
      Economic::Entity::Handle.build({:id2 => 42}).should == Economic::Entity::Handle.new({:id2 => 42})
    end

    it "returns a given handle" do
      handle = Economic::Entity::Handle.new({})
      Economic::Entity::Handle.build(handle).should === handle
    end
  end

  describe ".to_hash" do
    subject { Economic::Entity::Handle.new({:id => 42, :number => 37, :serial_number => 7}) }

    it "should return a handle for putting into the body of a SOAP request" do
      subject.to_hash.should == {'Id' => 42, 'Number' => 37, 'SerialNumber' => 7}
    end

    it "includes only the named value in the hash" do
      subject.to_hash(:id).should == {'Id' => 42}
    end

    it "includes only the named values in the hash" do
      subject.to_hash([:id, :serial_number]).should == {'Id' => 42, 'SerialNumber' => 7}
    end
  end

end

