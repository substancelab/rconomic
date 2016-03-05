require "./spec/spec_helper"

describe Economic::CashBookEntry do
  let(:session) { make_session }
  subject { Economic::CashBookEntry.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::CashBookEntry.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a CashBookEntryProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CashBookEntryProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "#save" do
    it "should save it" do
      stub_request("CashBookEntry_CreateFromData", nil, :success)
      subject.save
    end

    it "builds and sends data to API" do
      time = Time.now
      subject.date = subject.start_date = time
      subject.account_handle = Economic::Entity::Handle.new(:number => 12)
      mock_request(
        :cash_book_entry_create_from_data, {
          "data" => {
            "AccountHandle" => {"Number" => 12},
            "Date" => time,
            "VoucherNumber" => 0,
            "Text" => "",
            "AmountDefaultCurrency" => 0,
            "Amount" => 0,
            "DueDate" => nil,
            "StartDate" => time,
            "EndDate" => nil
          }
        },
        :success
      )
      subject.save
    end

    it "can build a CashBookEntry with a CreditorHandle" do
      time = Time.now
      subject.date = subject.start_date = time
      subject.creditor_handle = Economic::Entity::Handle.new(:number => 12)
      mock_request(
        :cash_book_entry_create_from_data, {
          "data" => {
            "CreditorHandle" => {"Number" => 12},
            "Date" => time,
            "VoucherNumber" => 0,
            "Text" => "",
            "AmountDefaultCurrency" => 0,
            "Amount" => 0,
            "DueDate" => nil,
            "StartDate" => time,
            "EndDate" => nil
          }
        },
        :success
      )
      subject.save
    end
  end
end
