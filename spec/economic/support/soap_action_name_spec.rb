require 'spec_helper'

describe Economic::Support::SOAPActionName do
  subject { Economic::Support::SOAPActionName }

  it "returns full action name for the given class and soap action" do
    expect(
      subject.for_entity_with_action(Economic::Debtor, :get_data)
    ).to eq(:debtor_get_data)
  end

  it "returns full action name for a class given as strings" do
    expect(subject.for_entity_with_action("FooBar", "Stuff")).to eq(:foo_bar_stuff)
  end
end
