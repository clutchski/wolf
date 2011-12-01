#
# Tests for the engine class.
#


module "Engine"


test "elements", () ->

    e = new wolf.Engine("test-canvas")
    equals(e.elements.length, 0, "New canvas has no elements")

    r1 = new wolf.Rectangle()
    r2 = new wolf.Rectangle()
    r3 = new wolf.Rectangle()

    e.add(r1)
    equals(e.elements.length, 1, "Element was added")

    e.add(r2, r3)
    equals(e.elements.length, 3, "variadic add works")

    r1.destroy()
    equals(e.elements.length, 2, "Destroyed elements are removed")

    e.remove(r2)
    equals(e.elements.length, 1, "We can remove elements")

test 'step', () ->

    class TestElement extends wolf.Element
        elapse : (elapsed, iteration) ->
            console.log('aaa')
            ok(elapsed, "passed ms elapsed")
            ok(iteration, "passed iteration")
            @counter = if @counter? then @counter + 1 else 1

        render : () ->
            this

    # Start the engine, but don't automatically step, so we can control
    # those.
    engine = new wolf.Engine("test-canvas")
    engine.start()

    # Listen for elapsed events.
    element = new TestElement()
    engine.add(element)

    equals(element.counter, 2, "the elapsed handler was executed twice")
