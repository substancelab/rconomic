require './spec/spec_helper'

describe Economic::Endpoint do
  subject { Economic::Endpoint.new }

  describe "soap_action_name" do
    it "returns full action name for the given class and soap action" do
      subject.soap_action_name(Economic::Debtor, :get_data).should == :debtor_get_data
    end

    it "returns full action name for a class given as strings" do
      subject.soap_action_name("FooBar", "Stuff").should == :foo_bar_stuff
    end
  end
end
