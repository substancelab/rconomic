require "./spec/spec_helper"

describe Economic::ProductProxy do
  let(:session) { make_session }
  subject { Economic::ProductProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "find" do
    it "gets product data from API" do
      mock_request(
        "Product_GetData",
        {"entityHandle" => {"Number" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns Product object" do
      stub_request("Product_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Product)
    end
  end

  describe "find_by_number" do
    it "can find a product" do
      mock_request("Product_FindByNumber", {"number" => "1"}, :found)
      result = subject.find_by_number("1")
      expect(result).to be_instance_of(Economic::Product)
      expect(result.number).to eq("1")
      expect(result.partial).to be_truthy
      expect(result.persisted).to be_truthy
      expect(result.handle).to eq(Economic::Entity::Handle.new(:number => "1"))
    end

    it "returns nil when there is no product" do
      mock_request("Product_FindByNumber", {"number" => "1"}, :not_found)
      result = subject.find_by_number("1")
      expect(result).to be_nil
    end
  end

  describe "build" do
    subject { session.products.build }

    it "instantiates a new Product" do
      expect(subject).to be_instance_of(Economic::Product)
    end

    it "assigns the session to the Product" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#entity_class" do
    it "should return Economic::Product" do
      expect(Economic::ProductProxy.entity_class).to eq(Economic::Product)
    end
  end

  describe ".all" do
    it "returns a single product" do
      stub_request("Product_GetAll", nil, :single)
      mock_request(
        "Product_GetData",
        {"entityHandle" => {"Number" => "1"}},
        :success
      )
      all = subject.all
      expect(all.size).to eq(1)
      expect(all.first).to be_instance_of(Economic::Product)
    end

    it "returns multiple products" do
      mock_request("Product_GetAll", nil, :multiple)
      stub_request("Product_GetDataArray", nil, :multiple)
      all = subject.all
      expect(all.size).to eq(2)
      expect(all.first).to be_instance_of(Economic::Product)
    end
  end
end
