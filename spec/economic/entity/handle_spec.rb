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
      handle.should === original_handle
    end
  end

  describe ".to_hash" do
    subject { Economic::Entity::Handle.new({:id => 42, :number => 37}) }

    it "should return a handle for putting into the body of a SOAP request" do
      subject.to_hash.should == {'Id' => 42, 'Number' => 37}
    end
  end
end

