require "./spec/spec_helper"

describe Economic::Entity::Mapper do
  let(:entity) {
    double("Entity", :handle => Economic::Entity::Handle.new(:id => 42),
                     :creditor_handle => Economic::Entity::Handle.new(:number => 37),
                     :name => "David Brent",
                     :is_to_receive_email_copy_of_order => true)
  }

  let(:fields) {
    [
      ["Handle", :handle, proc { |v| v.to_hash }, :required],
      ["CreditorHandle", :creditor_handle, proc { |v| {"Number" => v[:number]} }],
      ["Id", :handle, proc { |v| v.id }, :required],
      ["Name", :name],
      ["IsToReceiveEmailCopyOfOrder", :is_to_receive_email_copy_of_order, proc { |v| v || false }, :required]
    ]
  }

  subject { Economic::Entity::Mapper.new(entity, fields) }

  describe "#to_hash" do
    it "returns a Hash with fields as per the field descriptions" do
      expect(subject.to_hash).to eq("Handle" => {"Id" => 42},
                                    "CreditorHandle" => {"Number" => 37},
                                    "Id" => 42,
                                    "Name" => "David Brent",
                                    "IsToReceiveEmailCopyOfOrder" => true)
    end
  end

  describe "when entity has no values" do
    let(:entity) {
      double("Entity", :handle => Economic::Entity::Handle.new({}),
                       :creditor_handle => nil,
                       :name => nil,
                       :number => nil,
                       :is_to_receive_email_copy_of_order => nil)
    }

    subject { Economic::Entity::Mapper.new(entity, fields) }

    it "returns the minimal set of required fields" do
      expect(subject.to_hash).to eq("Handle" => {},
                                    "Id" => nil,
                                    "IsToReceiveEmailCopyOfOrder" => false)
    end
  end
end
