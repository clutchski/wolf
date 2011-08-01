#
# Timber canvas tests.
#


module "timber.Canvas"


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



module "timber.Point"

test "equals", () ->

    eq = (x1, y1, x2, y2) ->
        p1 = new timber.Point(x1, y1)
        p2 = new timber.Point(x2, y2)
        return p1.equals(p2)

    # Some equality tests.
    for c in [0, -1, 10, 20, 0.5, 0.7]
        ok( eq(c, c, c, c), "Point is equal: #{c}")

    # Some inequality tests.
    ok(not eq(1, 1, 1, 2), "Shouldn't be equal")
    ok(not eq(1, 2, 1.0, 1), "Shouldn't be equal")

 
module "timber.Vector"

test "length", () ->
    length = (x, y) ->
        return new timber.Vector(x, y).length()
    equals(length(0, 0), 0, "No length is zero")
    equals(length(1, 0), 1, "x unit vector has length 1")
    equals(length(0, 1), 1, "y unit vector has length 1")
    equals(length(3, 4), 5, "Pythagoras works")
    equals(length(-3, 4), 5, "Pythagoras works with negative numbers")

