require './spec/spec_helper'
require 'economic/mappers/creditor_contact_mapper'

describe Economic::Mappers::CreditorContactMapper do
  let(:creditor_contact) { double("CreditorContact", {
    :handle => Economic::Entity::Handle.new(:id => 42),
    :id => 42,
    :creditor_handle => Economic::Entity::Handle.new(:id => 37),
    :name => "Brick Top",
    :telephone_number => "1234567",
    :email => "nemesis@piggies.co.uk",
    :comments => "A righteous infliction of retribution manifested by an appropriate agent.",
    :external_id => 1
  }) }

  subject { Economic::Mappers::CreditorContactMapper.new(creditor_contact) }

  it "returns the fields formatted for the SOAP endpoint" do
    subject.to_hash.keys.should == [
      "Handle",
      "Id",
      "CreditorHandle",
      "Name",
      "Number",
      "TelephoneNumber",
      "Email",
      "Comments",
      "ExternalId"
    ]
  end

  context "when CreditorContact contains the minimum set of values" do
    let(:creditor_contact) { double("CreditorContact", {
      :handle => Economic::Entity::Handle.new({}),
      :id => nil,
      :creditor_handle => nil,
      :name => nil,
      :telephone_number => nil,
      :email => nil,
      :comments => nil,
      :external_id => nil
    }) }

    it "returns the minimal set of fields" do
      subject.to_hash.should == {
        "Handle" => {},
        "Number" => nil
      }
    end
  end
end
