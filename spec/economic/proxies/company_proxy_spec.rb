require "./spec/spec_helper"

describe Economic::CompanyProxy do
  let(:session) { make_session }
  subject { Economic::CompanyProxy.new(session) }

  describe ".get" do
    let!(:company) { Economic::Company.new.tap { |e| e.session = session } }

    it "Calls CompanyGet endpoint" do
      mock_request("Company_Get", nil, :success)
      stub_request("Company_GetData",  {"entityHandle" => {"Number" => "string"}}, :success)
      company.get
    end

    it "Calls CopmanyGetData endpoint with valid data" do
      stub_request("Company_Get", nil, :success)
      mock_request("Company_GetData",  {"entityHandle" => {"Number" => "string"}}, :success)
      company.get
    end

    it "Returns a valid company" do
      stub_request("Company_Get", nil, :success)
      stub_request("Company_GetData",  {"entityHandle" => {"Number" => "string"}}, :success)
      expectation = {:handle => {:number => "string"},
                     :number                => "string",
                     :base_currency_handle  => {:code => "string"},
                     :name                  => "string",
                     :address1              => "string",
                     :address2              => "string",
                     :postal_code           => "string",
                     :city                  => "string",
                     :county                => "string",
                     :country               => "string",
                     :telephone_number      => "string",
                     :fax_number            => "string",
                     :mobile_number         => "string",
                     :contact               => "string",
                     :web_site              => "string",
                     :email                 => "string",
                     :ci_number             => "string",
                     :vat_number            => "string",
                     :sign_up_date          => "dateTime"}
      expect(company.get).to eq expectation
    end
  end
end
