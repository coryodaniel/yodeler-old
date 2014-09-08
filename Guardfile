guard :rspec, all_on_start: true, all_after_pass: true do
  watch 'spec/spec_helper.rb'
  watch(%r{^spec/.+_spec\.rb$})
end

guard :bundler do
  watch('Gemfile')
  watch('yodeler.gemspec')
end