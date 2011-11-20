#
# A guard file to trigger builds whenever the source changes.
#

guard 'shell' do
  watch(%r{src/}) { `rake build`}
end

guard 'shell' do
  watch(%r{tests/}) { `rake test:build` }
end

guard 'shell' do
  watch(%r{examples/}) { `rake examples:build` }
end
