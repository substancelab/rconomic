guard(
  "rspec",
  :cmd => "rspec",
  :all_after_pass => false,
  :all_on_start => false,
  :failed_mode => :keep
) do
  watch("spec/spec_helper.rb") { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
