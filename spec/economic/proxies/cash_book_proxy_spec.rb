require './spec/spec_helper'

describe Economic::CashBookProxy do

  let(:session) { make_session }
  subject { Economic::CashBookProxy.new(session) }

  describe ".new" do

    it "stores session" do
      subject.session.should === session
    end

  end

  describe ".build" do

    it "instantiates a new CashBook" do
      subject.build.should be_instance_of(Economic::CashBook)
    end

    it "assigns the session to the CashBook" do
      subject.build.session.should === session
    end

  end

  describe ".all" do

    it "returns multiple cashbooks" do
      savon.expects('CashBook_GetAll').returns(:multiple)
      savon.expects('CashBook_GetName').returns(:success)
      savon.expects('CashBook_GetName').returns(:success)
      all = subject.all
      all.size.should == 2
      all[0].should be_instance_of(Economic::CashBook)
      all[1].should be_instance_of(Economic::CashBook)
    end

  end

  describe ".get_name" do

    it 'returns a cash book with a name' do
      savon.expects('CashBook_GetName').with("cashBookHandle" => { "Number" => "52" }).returns(:success)
      result = subject.get_name("52")
      result.should be_instance_of(Economic::CashBook)
      result.number.should == "52"
      result.name.should be_a(String)
    end

  end

end
