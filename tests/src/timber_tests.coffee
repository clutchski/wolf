#
# Timber canvas tests.
#


module "timber.test.Canvas"


test "Non-existant canvas", () ->
    raises(() ->
        c = new timber.Canvas("a-non-existant-id")
    , "A canvas that doesn't exist should throw an error")


test "No elements", () ->
    c = new timber.Canvas("test-canvas")
    equals(c.elements.length, 0, "New canvas has no elements")

test "Add elements", () ->
    c = new timber.Canvas("test-canvas")
    c.add(new timber.Element())
    equals(c.elements.length, 1, "Element was added")
    


