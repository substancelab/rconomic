require './spec/spec_helper'
require 'economic/mappers/debtor_contact_mapper'

describe Economic::Mappers::DebtorContactMapper do
  let(:debtor) { double("Debtor", {
    :handle => Economic::Entity::Handle.new(:id => 37),
  }) }
  let(:debtor_contact) { double("DebtorContact", {
    :comments => "If you want me, come down and get me!",
    :debtor => debtor,
    :email => "franke@gaden.dk",
    :external_id => "ch0391821",
    :handle => Economic::Entity::Handle.new(:id => 42),
    :is_to_receive_email_copy_of_order => true,
    :is_to_receive_email_copy_of_invoice => true,
    :name => "Frank",
    :number => 37,
    :telephone_number => "12345678"
  }) }

  subject { Economic::Mappers::DebtorContactMapper.new(debtor_contact) }

  it "returns the fields formatted for the SOAP endpoint" do
    subject.to_hash.keys.should == [
      "Handle",
      "Id",
      "DebtorHandle",
      "Name",
      "Number",
      "TelephoneNumber",
      "Email",
      "Comments",
      "ExternalId",
      "IsToReceiveEmailCopyOfOrder",
      "IsToReceiveEmailCopyOfInvoice"
    ]
  end

  context "when DebtorContact contains the minimum set of values" do
    let(:debtor_contact) { double("DebtorContact", {
      :comments => nil,
      :debtor => nil,
      :email => nil,
      :external_id => nil,
      :handle => Economic::Entity::Handle.new({}),
      :is_to_receive_email_copy_of_order => nil,
      :is_to_receive_email_copy_of_invoice => nil,
      :name => nil,
      :number => nil,
      :telephone_number => nil
    }) }

    it "returns the minimal set of fields" do
      subject.to_hash.should == {
        "Handle" => {},
        "Id" => nil,
        "Name" => nil,
        "IsToReceiveEmailCopyOfOrder" => false,
        "IsToReceiveEmailCopyOfInvoice" => false
      }
    end
  end
end
