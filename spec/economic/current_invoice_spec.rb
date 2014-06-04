require './spec/spec_helper'

describe Economic::CurrentInvoice do
  let(:session) { make_session }
  subject { (i = Economic::CurrentInvoice.new( :id => 512 )).tap { i.session = session } }

  it "inherits from Economic::Entity" do
    expect(Economic::CurrentInvoice.ancestors).to include(Economic::Entity)
  end

  describe "new" do
    it "initializes lines as an empty proxy" do
      expect(subject.lines).to be_instance_of(Economic::CurrentInvoiceLineProxy)
      expect(subject.lines).to be_empty
    end
  end

  describe ".key" do
    it "should == :current_invoice" do
      expect(Economic::CurrentInvoice.key).to eq(:current_invoice)
    end
  end

  describe ".proxy" do
    it "should return a CurrentInvoiceProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "save" do
    context "when successful" do
      it "builds and sends data to API" do
        time = Time.now
        subject.date = time
        subject.attention_handle = Economic::Entity::Handle.new(:id => 42)
        subject.term_of_payment_handle = Economic::Entity::Handle.new(:id => 37)
        subject.currency_handle = Economic::Entity::Handle.new({:code => "BTC"})
        subject.layout_handle = Economic::Entity::Handle.new(:id => 314)

        mock_request(
          "CurrentInvoice_CreateFromData", {
            "data" => {
              "Id" => 512,
              "DebtorName" => nil,
              "AttentionHandle" => {"Id" => 42},
              "Date" => time.iso8601,
              "TermOfPaymentHandle" => {"Id" => 37},
              "DueDate" => nil,
              "CurrencyHandle" => {"Code" => "BTC"},
              "ExchangeRate" => 100,
              "IsVatIncluded" => nil,
              "LayoutHandle" => {"Id" => 314},
              "DeliveryDate" => nil,
              "NetAmount" => 0,
              "VatAmount" => 0,
              "GrossAmount" => 0,
              "Margin" => 0,
              "MarginAsPercent" => 0
            }
          },
          :success
        )
        subject.save
      end

      it "updates id with the created id" do
        stub_request('CurrentInvoice_CreateFromData', nil, :success)
        subject.save
        expect(subject.id).to eq(42)
      end

      it "updates handle with the created id" do
        stub_request('CurrentInvoice_CreateFromData', nil, :success)

        invoice = Economic::CurrentInvoice.new({})
        invoice.session = session

        # This line memoizes the handle with the wrong/old id (0). This is what
        # we're testing changes
        expect(invoice.handle.id).to eq(0)

        invoice.save
        expect(invoice.handle).to eq(Economic::Entity::Handle.new(:id => 42))
      end

      context "when invoice has lines" do
        before :each do
          stub_request('CurrentInvoice_CreateFromData', nil, :success)

          2.times do
            line = Economic::CurrentInvoiceLine.new
            allow(line).to receive(:save)
            subject.lines << line
          end
        end

        it "adds the lines to the invoice" do
          subject.lines.each do |line|
            expect(line).to receive(:invoice=).with(subject)
          end

          subject.save
        end

        it "assigns the invoice session to each line" do
          subject.lines.each do |line|
            expect(line).to receive(:session=).with(subject.session)
          end

          subject.save
        end

        it "saves each line" do
          subject.lines.each do |line|
            expect(line).to receive(:save)
          end

          subject.save
        end
      end
    end
  end

  describe "#book" do
    it 'should book the current invoice and return the created invoice object' do
      stub_request('CurrentInvoice_Book', nil, :success)
      mock_request("Invoice_GetData", {'entityHandle' => { 'Number' => '328' }}, :success)
      expect(subject.book).to be_instance_of(Economic::Invoice)
    end

    it 'should request with the right key for handle' do
      mock_request("CurrentInvoice_Book", {'currentInvoiceHandle' => { 'Id' => 512 }}, :success)
      stub_request('Invoice_GetData', nil, :success)
      subject.book
    end
  end

  describe "#book_with_number" do
    it 'should book the current invoice with the given number and return the created invoice object' do
      stub_request('CurrentInvoice_BookWithNumber', nil, :success)
      mock_request("Invoice_GetData", {'entityHandle' => { 'Number' => '123' }}, :success)
      expect(subject.book_with_number(123)).to be_instance_of(Economic::Invoice)
    end

    it 'should request with the right key for handle' do
      mock_request("CurrentInvoice_BookWithNumber", {'currentInvoiceHandle' => { 'Id' => 512 }, 'number' => 123}, :success)
      stub_request('Invoice_GetData', nil, :success)
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
      expect(subject.attention).to eq(contact)
    end

    it "updates the handle" do
      handle = Economic::Entity::Handle.new(:number => 42)
      contact.handle = handle
      subject.attention = contact
      expect(subject.attention_handle).to eq(handle)
    end
  end

  describe "#debtor" do
    let(:debtor) {
      Economic::Debtor.new.tap do |c|
        c.session = session
        c.number = 5
      end
    }

    it "should be set- and gettable" do
      subject.debtor = debtor
      expect(subject.debtor).to eq(debtor)
    end

    it "updates the handle" do
      handle = Economic::Entity::Handle.new(:number => 42)
      debtor.handle = handle
      subject.debtor = debtor
      expect(subject.debtor_handle).to eq(handle)
    end
  end
end
