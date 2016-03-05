require "./spec/spec_helper"

describe Economic::CashBookProxy do
  let(:session) { make_session }
  subject { Economic::CashBookProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new CashBook" do
      expect(subject.build).to be_instance_of(Economic::CashBook)
    end

    it "assigns the session to the CashBook" do
      expect(subject.build.session).to equal(session)
    end
  end

  describe ".all" do
    it "returns multiple cashbooks" do
      stub_request("CashBook_GetAll", nil, :multiple)
      stub_request("CashBook_GetDataArray", nil, :multiple)

      all = subject.all
      expect(all.size).to eq(2)
      all.each { |cash_book| expect(cash_book).to be_instance_of(Economic::CashBook) }
    end

    it "properly fills out handles of cash books" do
      # Issue #12
      stub_request("CashBook_GetAll", nil, :multiple)
      stub_request("CashBook_GetDataArray", nil, :multiple)
      stub_request("CashBook_GetData", nil, :success)
      stub_request("CashBook_GetAll", nil, :multiple)
      stub_request("CashBook_GetDataArray", nil, :multiple)

      cash_book = subject.find(subject.all.first.handle)
      expect(subject.all.first.handle).to eq(cash_book.handle)
    end
  end

  describe ".get_name" do
    it "returns a cash book with a name" do
      mock_request("CashBook_GetName", {"cashBookHandle" => {"Number" => "52"}}, :success)
      result = subject.get_name("52")
      expect(result).to be_instance_of(Economic::CashBook)
      expect(result.number).to eq("52")
      expect(result.name).to be_a(String)
    end
  end

  describe "#last" do
    it "returns the last cash book" do
      stub_request("CashBook_GetAll", nil, :multiple)
      stub_request("CashBook_GetDataArray", nil, :multiple)

      expect(subject.all.last.name).to eq("Another cash book")
    end
  end

  describe "#[]" do
    it "returns the specific cash book" do
      stub_request("CashBook_GetAll", nil, :multiple)
      stub_request("CashBook_GetDataArray", nil, :multiple)

      expect(subject.all[1].name).to eq("Another cash book")
    end
  end
end
