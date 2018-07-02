# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :test do
  gem "codeclimate-test-reporter", :require => false
  gem "rake"
  gem "simplecov", :require => false
end

# Not required to develop rconomic, but useful. See file
# mappings in Guardfile
group :guard do
  gem "guard"
  gem "guard-rspec"
end
