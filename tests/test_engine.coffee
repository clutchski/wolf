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

