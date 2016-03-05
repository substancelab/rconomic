require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "savon"
require "savon/mock/spec_helper"

require "./lib/rconomic"

RSpec.configure do |config|
  config.include Savon::SpecHelper

  config.before :each do
    # Ensure we don't actually send requests over the network
    expect(HTTPI).to receive(:get).never
    expect(HTTPI).to receive(:post).never
    savon.mock!
  end

  config.after :each do
    savon.unmock!
  end
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }
