require './spec/spec_helper'

describe Economic::CurrentInvoiceLineProxy do
  let(:session) { make_session }
  let(:invoice) { make_current_invoice(:session => session) }
  subject { Economic::CurrentInvoiceLineProxy.new(invoice) }

  describe "new" do
    it "stores owner" do
      subject.owner.should == invoice
    end

    it "stores session" do
      subject.session.should == invoice.session
    end
  end

  describe ".append" do
    it "ignores duplicated lines" do
      line = Economic::CurrentInvoiceLine.new
      subject.append(line)
      subject.append(line)
      subject.size.should == 1
    end
  end

  describe ".build" do
    it "instantiates a new CurrentInvoiceLine" do
      subject.build.should be_instance_of(Economic::CurrentInvoiceLine)
    end

    it "assigns the session to the CurrentInvoiceLine" do
      subject.build.session.should == session
    end

    it "should not build a partial CurrentInvoiceLine" do
      subject.build.should_not be_partial
    end

    it "adds the built line to proxy items" do
      line = subject.build
      subject.first.should == line
    end

    context "when owner is a CurrentInvoice" do
      subject { invoice.lines }

      it "should use the Debtors session" do
        subject.build.session.should == invoice.session
      end

      it "should initialize with values from CurrentInvoice" do
        invoice_line = subject.build
        invoice_line.invoice_handle.should == invoice.handle
      end
    end
  end

  describe ".find" do
    before :each do
      stub_request('CurrentInvoiceLine_GetData', nil, :success)
    end

    it "gets invoice_line data from API" do
      mock_request('CurrentInvoiceLine_GetData', {'entityHandle' => {'Number' => 42}}, :success)
      subject.find(42)
    end

    it "returns CurrentInvoiceLine object" do
      subject.find(42).should be_instance_of(Economic::CurrentInvoiceLine)
    end
  end

  describe "enumerable" do
    it "can be empty" do
      subject.should be_empty
    end

    it "can be appended to" do
      line = Economic::CurrentInvoiceLine.new
      subject << line
      subject.last.should == line
    end

    it "can be iterated over" do
      line = Economic::CurrentInvoiceLine.new
      subject << line
      subject.all? { |l| l.is_a?(Economic::CurrentInvoiceLine) }.should be_true
    end
  end
end
