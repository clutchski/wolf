#
# Tests for the engine class.
#


module "Engine"


test "elements", () ->
    e = new timber.Engine("test-canvas")
    equals(e.elements.length, 0, "New canvas has no elements")

    e.add(new timber.Rectangle())
    equals(e.elements.length, 1, "Element was added")

    e.add(new timber.Rectangle(), new timber.Rectangle())
    equals(e.elements.length, 3, "variadic add works")

