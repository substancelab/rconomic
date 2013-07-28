require './spec/spec_helper'

describe Economic::CurrentInvoice do
  let(:session) { make_session }
  subject { (i = Economic::CurrentInvoice.new( :id => 512 )).tap { i.session = session } }

  it "inherits from Economic::Entity" do
    Economic::CurrentInvoice.ancestors.should include(Economic::Entity)
  end

  describe "new" do
    it "initializes lines as an empty proxy" do
      subject.lines.should be_instance_of(Economic::CurrentInvoiceLineProxy)
      subject.lines.should be_empty
    end
  end

  describe ".key" do
    it "should == :current_invoice" do
      Economic::CurrentInvoice.key.should == :current_invoice
    end
  end

  describe ".proxy" do
    it "should return a CurrentInvoiceProxy" do
      subject.proxy.should be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

  describe "save" do
    context "when successful" do
      before :each do
        stub_request('CurrentInvoice_CreateFromData', nil, :success)
      end

      it "updates id with the created id" do
        subject.save
        subject.id.should == 42
      end

      it "updates handle with the created id" do
        invoice = Economic::CurrentInvoice.new({})
        invoice.session = session

        # This line memoizes the handle with the wrong/old id (0). This is what
        # we're testing changes
        invoice.handle.id.should == 0

        invoice.save
        invoice.handle.should == Economic::Entity::Handle.new(:id => 42)
      end

      context "when invoice has lines" do
        before :each do
          2.times do
            line = Economic::CurrentInvoiceLine.new
            line.stub(:save)
            subject.lines << line
          end
        end

        it "adds the lines to the invoice" do
          subject.lines.each do |line|
            line.should_receive(:invoice=).with(subject)
          end

          subject.save
        end

        it "assigns the invoice session to each line" do
          subject.lines.each do |line|
            line.should_receive(:session=).with(subject.session)
          end

          subject.save
        end

        it "saves each line" do
          subject.lines.each do |line|
            line.should_receive(:save)
          end

          subject.save
        end
      end
    end
  end

  describe "#book" do
    before :each do
      stub_request('CurrentInvoice_Book', nil, :success)
      stub_request('Invoice_GetData', nil, :success)
    end

    it 'should book the current invoice and return the created invoice object' do
      mock_request("Invoice_GetData", {'entityHandle' => { 'Number' => 328 }}, :success)
      subject.book.should be_instance_of(Economic::Invoice)
    end

    it 'should request with the right key for handle' do
      mock_request("CurrentInvoice_Book", {'currentInvoiceHandle' => { 'Id' => 512 }}, :success)
      subject.book
    end
  end

  describe "#book_with_number" do
    it 'should book the current invoice with the given number and return the created invoice object' do
      stub_request('CurrentInvoice_BookWithNumber', nil, :success)
      mock_request("Invoice_GetData", {'entityHandle' => { 'Number' => 123 }}, :success)
      subject.book_with_number(123).should be_instance_of(Economic::Invoice)
    end

    it 'should request with the right key for handle' do
      stub_request('Invoice_GetData', nil, :success)
      mock_request("CurrentInvoice_BookWithNumber", {'currentInvoiceHandle' => { 'Id' => 512 }, 'number' => 123}, :success)
      subject.book_with_number(123)
    end
  end

  describe "#attention" do
    let(:contact) {
      c = Economic::DebtorContact.new(
        :handle => Economic::Entity::Handle.new({:id => 12, :number => 34})
      )
      c.session = session
      c
    }

    it "should be set- and gettable" do
      subject.attention = contact
      subject.attention_handle.should == contact.handle
      subject.attention.should == contact
    end
  end

  describe "#debtor" do
    let(:debtor) { (c = Economic::Debtor.new).tap { c.session = session }}

    it "should be set- and gettable" do
      subject.debtor = debtor
      subject.debtor_handle.should == debtor.handle
      subject.debtor.should == debtor
    end
  end
end
