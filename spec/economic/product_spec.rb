require "./spec/spec_helper"

describe Economic::Product do
  let(:session) { make_session }
  subject { Economic::Product.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Product.ancestors).to include(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::Product }

    describe ".proxy" do
      it "should return ProductProxy" do
        expect(subject.proxy).to eq(Economic::ProductProxy)
      end
    end

    describe ".key" do
      it "should == :product" do
        expect(Economic::Product.key).to eq(:product)
      end
    end
  end

  describe ".proxy" do
    it "should return a CreditorProxy" do
      expect(subject.proxy).to be_instance_of(Economic::ProductProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "#save" do
    it "should save it" do
      stub_request("Product_CreateFromData", nil, :success)
      subject.save
    end

    it "builds and sends data to API" do
      mock_request(
        :product_create_from_data, {
          "data" => {
            "Handle" => {},
            "Number" => nil,
            "ProductGroupHandle" => {"Number" => 1},
            "Name" => nil,
            "SalesPrice" => nil,
            "CostPrice" => nil,
            "RecommendedPrice" => nil,
            "UnitHandle" => {"Number" => 2},
            "IsAccessible" => nil,
            "Volume" => nil,
            "DepartmentHandle" => {"Number" => 1},
            "DistributionKeyHandle" => {"Number" => 314}
          }
        },
        :success
      )

      subject.product_group_handle = Economic::Entity::Handle.new(:number => 1)
      subject.unit_handle = Economic::Entity::Handle.new(:number => 2)
      subject.department_handle = Economic::Entity::Handle.new(:number => 1)
      subject.distribution_key_handle = Economic::Entity::Handle.new(:number => 314)

      subject.save
    end
  end
end
