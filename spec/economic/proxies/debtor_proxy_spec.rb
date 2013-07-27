require './spec/spec_helper'

describe Economic::DebtorProxy do
  let(:session) { make_session }
  subject { Economic::DebtorProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "find" do
    it "gets debtor data from API" do
      mock_request('Debtor_GetData', {'entityHandle' => {'Number' => 42}}, :success)
      subject.find(42)
    end

    it "returns Debtor object" do
      stub_request('Debtor_GetData', nil, :success)
      subject.find(42).should be_instance_of(Economic::Debtor)
    end
  end

  describe "find_by_ci_number" do
    it "uses FindByCINumber on API" do
      mock_request('Debtor_FindByCINumber', {'ciNumber' => '12345678'}, :many)
      subject.find_by_ci_number('12345678')
    end

    context "when many debtors exist" do
      before :each do
        stub_request('Debtor_FindByCINumber', nil, :many)
      end

      let(:results) { subject.find_by_ci_number('12345678') }

      it "returns a Debtor object for each result" do
        results.size.should == 2
        results.all? { |result| result.should be_instance_of(Economic::Debtor) }
      end

      it "returns partial Debtor objects" do
        results.all? { |result| result.should be_partial }
      end

      it "returns persisted Debtor objects" do
        results.all? { |result| result.should be_persisted }
      end
    end
  end

  describe "find_by_number" do
    it "can find a debtor" do
      mock_request('Debtor_FindByNumber', {'number' => '1'}, :found)
      result = subject.find_by_number('1')
      result.should be_instance_of(Economic::Debtor)
      result.number.should == 1
      result.partial.should be_true
      result.persisted.should be_true
      result.handle.should == Economic::Entity::Handle.new({:number => 1})
    end

    it "returns nil when there is no debtor" do
      mock_request('Debtor_FindByNumber', {'number' => '1'}, :not_found)
      result = subject.find_by_number('1')
      result.should be_nil
    end
  end

  describe "next_available_number" do
    it "gets the next available debtor number from API" do
      mock_request('Debtor_GetNextAvailableNumber', nil, :success)
      subject.next_available_number.should == '105'
    end
  end

  describe "build" do
    subject { session.debtors.build }

    it "instantiates a new Debtor" do
      subject.should be_instance_of(Economic::Debtor)
    end

    it "assigns the session to the Debtor" do
      subject.session.should === session
    end
  end

  describe "#entity_class" do
    it "should return Economic::Debtor" do
      Economic::DebtorProxy.entity_class.should == Economic::Debtor
    end
  end

  # Complete specs in current_invoice, no point in duplicating them here, just ensuring that
  # it handles debtors "Number" id.
  describe ".all" do
    it "returns a single debtor" do
      mock_request('Debtor_GetAll', nil, :single)
      mock_request('Debtor_GetData', {'entityHandle' => {'Number' => 1}}, :success)
      all = subject.all
      all.size.should == 1
      all.first.should be_instance_of(Economic::Debtor)
    end

    it "returns multiple debtors" do
      mock_request('Debtor_GetAll', nil, :multiple)
      mock_request('Debtor_GetDataArray', :any, :multiple)
      all = subject.all
      all.size.should == 2
      all.first.should be_instance_of(Economic::Debtor)
    end
  end
end
