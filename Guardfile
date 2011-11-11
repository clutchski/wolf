#
# A guard file to trigger builds whenever the source changes.
#

guard 'shell' do
    watch(%r{src/}) { `rake build`}
end
