#
# Tests for the Environment class.
#


module('Environment')


class TestElement extends timber.Element

    @key = 'asdf'
    

test 'contains', () ->
    e = new timber.Environment({width:800, height:600})
    
    ok(e.contains(new TestElement({x:300, y: 300}), "contains"))
    ok(not e.contains(new TestElement({x:1300, y: 300}), "doesnt contain"))

