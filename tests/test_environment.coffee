#
# Tests for the Environment class.
#


module('Environment')



test 'contains', () ->
    e = new wolf.Environment({width:800, height:600})

    ok(e.contains(new wolf.Element({x:300, y: 300}), "contains"))
    ok(not e.contains(new wolf.Element({x:1300, y: 300}), "doesnt contain"))


