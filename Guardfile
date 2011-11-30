#
# A guard file to trigger builds whenever the source changes.
#

guard 'shell' do
  watch(%r{src/}) { `rake build` }
  watch(%r{tests/}) { `rake test:build` }
  watch(%r{examples/}) { `rake examples:build` }
end
