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
        savon.stubs('CurrentInvoice_CreateFromData').returns(:success)
      end

      context "when invoice has lines" do
        before :each do
          2.times do
            line = Economic::CurrentInvoiceLine.new
            line.stubs(:save)
            subject.lines << line
          end
        end

        it "adds the lines to the invoice" do
          subject.lines.each do |line|
            line.expects(:invoice=).with(subject)
          end

          subject.save
        end

        it "assigns the invoice session to each line" do
          subject.lines.each do |line|
            line.expects(:session=).with(subject.session)
          end

          subject.save
        end

        it "saves each line" do
          subject.lines.each do |line|
            line.expects(:save)
          end

          subject.save
        end
      end
    end
  end

  describe "#book" do
    before :each do
      savon.stubs('CurrentInvoice_Book').returns(:success)
    end

    it 'should book the current invoice and return an invoice number' do
      subject.book.should == 328
    end

    it 'should request with the right key for handle' do
      savon.expects("CurrentInvoice_Book").with('currentInvoiceHandle' => { 'Id' => 512 }).returns(:success)
      subject.book
    end
  end

  describe "#attention" do
    let(:contact) { (c = Economic::DebtorContact.new).tap { c.session = session }}

    it "should be set- and gettable" do
      subject.attention = contact
      subject.attention_handle.should == contact.handle
      subject.attention.should == contact
    end
  end
end
