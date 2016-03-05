require "./spec/spec_helper"

describe Economic::Entity::Handle do
  describe "equality" do
    let(:handle_a) { Economic::Entity::Handle.new(:id => 1, :number => 2) }
    let(:handle_b) { Economic::Entity::Handle.new(:id => 1, :number => 2) }
    let(:handle_c) { Economic::Entity::Handle.new(:id => 1) }
    let(:handle_d) { Economic::Entity::Handle.new(:id => 1, :number => 3) }

    it "should be equal when both id and number are equal" do
      expect(handle_a).to eq(handle_b)
    end

    it "should not be equal when id or number is missing" do
      expect(handle_a).not_to eq(handle_c)
    end

    it "should not be equal when id or number is equal and the other isn't" do
      expect(handle_a).not_to eq(handle_d)
    end

    it "should not equal if both are empty" do
      expect(Economic::Entity::Handle.new({})).not_to eq(Economic::Entity::Handle.new({}))
    end

    it "should be equal if both are the same object" do
      handle = Economic::Entity::Handle.new({})
      expect(handle).to eq(handle)
    end

    describe "CashBookEntry handles" do
      let(:handle_a) { Economic::Entity::Handle.new(:id1 => 1, :id2 => 2) }

      context "when id1 and id2 values are equal" do
        let(:handle_b) { Economic::Entity::Handle.new(:id1 => 1, :id2 => 2) }

        it "should be equal" do
          expect(handle_a).to eq(handle_b)
        end
      end

      context "when id1 and id2 values are different" do
        let(:handle_b) { Economic::Entity::Handle.new(:id1 => 11, :id2 => 12) }

        it "should_not be equal" do
          expect(handle_a).not_to eq(handle_b)
        end
      end
    end
  end

  describe ".new" do
    it "should raise error if argument isn't supported" do
      expect(lambda do
        Economic::Entity::Handle.new(true)
      end).to raise_error(ArgumentError)
    end

    it "should raise error if argument is nil" do
      expect(lambda do
        Economic::Entity::Handle.new(nil)
      end).to raise_error(ArgumentError)
    end

    it "should raise error if argument contains invalid key" do
      expect(lambda do
        Economic::Entity::Handle.new(:Numeric => 12)
      end).to raise_error(ArgumentError)
    end

    it "should set id" do
      handle = Economic::Entity::Handle.new(:id => 12)
      expect(handle.id).to eq(12)
    end

    it "should set number" do
      handle = Economic::Entity::Handle.new(:number => 12)
      expect(handle.number).to eq(12)
    end

    it "should set both id and number" do
      handle = Economic::Entity::Handle.new(:id => 37, :number => 42)
      expect(handle.id).to eq(37)
      expect(handle.number).to eq(42)
    end

    it "should set id1 and id2" do
      handle = Economic::Entity::Handle.new(:id1 => 37, :id2 => 42)
      expect(handle.id1).to eq(37)
      expect(handle.id2).to eq(42)
    end

    it "should to_i values" do
      handle = Economic::Entity::Handle.new(:id => "37", :number => "42")
      expect(handle.id).to eq(37)
    end

    it "should not to_i nil values" do
      handle = Economic::Entity::Handle.new(:id => "37")
      expect(handle.id).to eq(37)
      expect(handle.number).to be_nil
    end

    it "should accept a Hash with capitalized keys" do
      handle = Economic::Entity::Handle.new("Id" => 37, "Number" => 42)
      expect(handle.id).to eq(37)
      expect(handle.number).to eq(42)
    end

    it "should accept another Handle" do
      original_handle = Economic::Entity::Handle.new(:id => 37)
      handle = Economic::Entity::Handle.new(original_handle)
      expect(handle.id).to eq(37)
      expect(handle.number).to be_nil
      expect(handle).to eq(original_handle)
    end
  end

  describe ".build" do
    it "returns nil when given nil" do
      expect(Economic::Entity::Handle.build(nil)).to be_nil
    end

    it "returns empty handle when hash is empty" do
      expect(Economic::Entity::Handle.build({})).to be_empty
    end

    it "returns nil when hash has no values" do
      expect(Economic::Entity::Handle.build(:id => nil, :number => nil)).to be_empty
    end

    it "returns handle when hash has values" do
      expect(Economic::Entity::Handle.build(:id2 => 42)).to eq(Economic::Entity::Handle.new(:id2 => 42))
    end

    it "returns a given handle" do
      handle = Economic::Entity::Handle.new({})
      expect(Economic::Entity::Handle.build(handle)).to equal(handle)
    end
  end

  describe "#empty?" do
    it "returns true when handle has no values" do
      expect(Economic::Entity::Handle.new({})).to be_empty
    end

    it "returns false when handle has a value" do
      expect(Economic::Entity::Handle.new(:serial_number => 12)).to_not be_empty
    end
  end

  describe ".to_hash" do
    subject { Economic::Entity::Handle.new(:id => 42, :number => 37, :serial_number => 7, :code => "USD", :name => "Bob", :vat_code => 1) }

    it "should return a handle for putting into the body of a SOAP request" do
      expect(subject.to_hash).to eq("Id" => 42, "Number" => 37, "SerialNumber" => 7, "Code" => "USD", "Name" => "Bob", "VatCode" => 1)
    end

    it "includes only the named value in the hash" do
      expect(subject.to_hash(:id)).to eq("Id" => 42)
    end

    it "includes only the named values in the hash" do
      expect(subject.to_hash([:id, :serial_number])).to eq("Id" => 42, "SerialNumber" => 7)
    end
  end
end
