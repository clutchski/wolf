#
# Tests for event binding and handling.
#

module "Events"


class BindTest
    
    testing : () ->
        return false

timber.extend(BindTest::, timber.Events)


test "bind", 5, () ->

    bt = new BindTest()

    bt.bind('first', (a1, a2) ->
        ok("first callback executed")
        equals(a1, 1, "first arg is passed")
        equals(a2, 2, "second arg is passed")
    )
    bt.bind('first', () ->
        ok("multiple callbacks work")
    )

    bt.bind('second', () ->
        ok("second callback executed")
    )

    bt.trigger('first', 1, 2)
    bt.trigger('second')
