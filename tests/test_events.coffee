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

    # Also a small implicit test of chaining
    bt.bind('first', (a1, a2) ->
        ok("first callback executed")
        equals(a1, 1, "first arg is passed")
        equals(a2, 2, "second arg is passed")
    ).bind('first', () ->
        ok("multiple callbacks work")
    ).bind('second', () ->
        ok("second callback executed")
    )

    bt.trigger('first', 1, 2)
    bt.trigger('second')

test "unbind", 1, () ->

    bt = new BindTest()

    # Create some callback functions.
    passingFunction = () ->
        ok(true, "correctly not bound")
    failingFunction = () ->
        ok(false, "this function should be unbound and never run")
    otherFunction = () ->
        ok(false, "this function should never be run either")
    
    # Bind the callbacks
    bt.bind('event', passingFunction)
    bt.bind('event', failingFunction)
    bt.bind('othernamespace', otherFunction)

    # Unbind a function by reference.
    bt.unbind('event', failingFunction).trigger('event')

    # Unbind a function by name.
    bt.unbind('event').trigger('event')

    # Unbind all functions.
    bt.unbind().trigger('othernamespace')
