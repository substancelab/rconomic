require "./spec/spec_helper"

describe Economic::DebtorProxy do
  let(:session) { make_session }
  subject { Economic::DebtorProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "find" do
    it "gets debtor data from API" do
      mock_request(
        "Debtor_GetData",
        {"entityHandle" => {"Number" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns Debtor object" do
      stub_request("Debtor_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Debtor)
    end
  end

  describe "find_by_ci_number" do
    it "uses FindByCINumber on API" do
      mock_request(
        "Debtor_FindByCINumber",
        {"ciNumber" => "12345678"},
        :many
      )
      subject.find_by_ci_number("12345678")
    end

    context "when many debtors exist" do
      before :each do
        stub_request("Debtor_FindByCINumber", nil, :many)
      end

      let(:results) { subject.find_by_ci_number("12345678") }

      it "returns a Debtor object for each result" do
        expect(results.size).to eq(2)
        results.all? { |result|
          expect(result).to be_instance_of(Economic::Debtor)
        }
      end

      it "returns partial Debtor objects" do
        results.all? { |result| expect(result).to be_partial }
      end

      it "returns persisted Debtor objects" do
        results.all? { |result| expect(result).to be_persisted }
      end
    end
  end

  describe "find_by_number" do
    it "can find a debtor" do
      mock_request("Debtor_FindByNumber", {"number" => "1"}, :found)
      result = subject.find_by_number("1")
      expect(result).to be_instance_of(Economic::Debtor)
      expect(result.partial).to be_truthy
      expect(result.persisted).to be_truthy
      expect(result.number).to eq("1")
      expect(result.handle).to eq(Economic::Entity::Handle.new(:number => "1"))
    end

    it "returns nil when there is no debtor" do
      mock_request("Debtor_FindByNumber", {"number" => "1"}, :not_found)
      result = subject.find_by_number("1")
      expect(result).to be_nil
    end
  end

  describe "find_by_telephone_and_fax_number" do
    it "can find a debtor" do
      mock_request(
        "Debtor_FindByTelephoneAndFaxNumber",
        {"telephoneAndFaxNumber" => "22334455"},
        :found
      )
      result = subject.find_by_telephone_and_fax_number("22334455")
      expect(result).to be_instance_of(Economic::Debtor)
      expect(result.number).to eq(1)
      expect(result.partial).to be_truthy
      expect(result.persisted).to be_truthy
    end

    it "returns nil when there is no debtor" do
      mock_request(
        "Debtor_FindByTelephoneAndFaxNumber",
        {"telephoneAndFaxNumber" => "22334455"},
        :not_found
      )
      result = subject.find_by_telephone_and_fax_number("22334455")
      expect(result).to be_nil
    end
  end

  describe "next_available_number" do
    it "gets the next available debtor number from API" do
      mock_request("Debtor_GetNextAvailableNumber", nil, :success)
      expect(subject.next_available_number).to eq("105")
    end
  end

  describe "build" do
    subject { session.debtors.build }

    it "instantiates a new Debtor" do
      expect(subject).to be_instance_of(Economic::Debtor)
    end

    it "assigns the session to the Debtor" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#entity_class" do
    it "should return Economic::Debtor" do
      expect(Economic::DebtorProxy.entity_class).to eq(Economic::Debtor)
    end
  end

  # Complete specs in current_invoice, no point in duplicating them here, just
  # ensuring that it handles debtors "Number" id.
  describe ".all" do
    it "returns a single debtor" do
      mock_request("Debtor_GetAll", nil, :single)
      mock_request(
        "Debtor_GetData",
        {"entityHandle" => {"Number" => "1"}},
        :success
      )
      all = subject.all
      expect(all.size).to eq(1)
      expect(all.first).to be_instance_of(Economic::Debtor)
    end

    it "returns multiple debtors" do
      mock_request("Debtor_GetAll", nil, :multiple)
      mock_request("Debtor_GetDataArray", :any, :multiple)
      all = subject.all
      expect(all.size).to eq(2)
      expect(all.first).to be_instance_of(Economic::Debtor)
    end
  end

  describe ".get_debtor_contacts" do
    let(:handle) { Economic::Entity::Handle.new(:number => 1) }
    it "gets debtor contact data from API" do
      mock_request(
        "Debtor_GetDebtorContacts",
        {"debtorHandle" => {"Number" => 1}},
        :multiple
      )
      subject.get_debtor_contacts(handle)
    end

    it "returns DebtorContact objects" do
      stub_request("Debtor_GetDebtorContacts", nil, :multiple)
      subject.get_debtor_contacts(handle).each do |d|
        expect(d).to be_instance_of(Economic::DebtorContact)
      end
    end
  end

  describe ".get_invoices" do
    let(:handle) { Economic::Entity::Handle.new(:number => 1) }
    it "gets invoice data from API" do
      mock_request(
        "Debtor_GetInvoices",
        {"debtorHandle" => {"Number" => 1}},
        :success
      )
      subject.get_invoices(handle)
    end

    it "returns Invoice object" do
      stub_request("Debtor_GetInvoices", nil, :success)
      subject.get_invoices(handle).each do |i|
        expect(i).to be_instance_of(Economic::Invoice)
      end
    end
  end

  describe ".get_order" do
    let(:handle) { Economic::Entity::Handle.new(:number => 1) }
    it "gets invoice data from API" do
      mock_request(
        "Debtor_GetOrders",
        {"debtorHandle" => {"Number" => 1}},
        :success
      )
      subject.get_orders(handle)
    end

    it "returns Order object" do
      stub_request("Debtor_GetOrders", nil, :success)
      subject.get_orders(handle).each do |i|
        expect(i).to be_instance_of(Economic::Order)
      end
    end

    it "sets the number" do
      stub_request("Debtor_GetOrders", nil, :success)
      subject.get_orders(handle).each do |i|
        expect(i.number).to eq(1)
      end
    end

    it "returns nil if no orders are found" do
      stub_request("Debtor_GetOrders", nil, :none)
      expect(
        subject.get_orders(handle)
      ).to be_nil
    end
  end
end
