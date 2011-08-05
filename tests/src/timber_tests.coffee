#
# Timber canvas tests.
#


module "timber.Canvas"


test "Non-existant canvas", () ->
    raises(() ->
        c = new timber.Canvas("a-non-existant-id")
    , "A canvas that doesn't exist should throw an error")



module "timber.Engine"

test "No elements", () ->
    c = new timber.Engine("test-canvas")
    equals(c.elements.length, 0, "New canvas has no elements")

test "Add elements", () ->
    c = new timber.Engine("test-canvas")
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

test "sum", () ->
    p = new timber.Point(1, 2)
    v = new timber.Vector(4, -5)

    p2 = p.sum(v)

    ok(p2 instanceof timber.Point, "summing vector and point produces a point")

    equals(p2.x, 5, "addition works")
    equals(p2.y, -3, "addition works")



module "timber.Vector"


test "length", () ->
    length = (x, y) ->
        return new timber.Vector(x, y).length()
    equals(length(0, 0), 0, "No length is zero")
    equals(length(1, 0), 1, "x unit vector has length 1")
    equals(length(0, 1), 1, "y unit vector has length 1")
    equals(length(3, 4), 5, "Classic pythagorarean vector works")
    equals(length(-3, 4), 5, "Works with negative numbers")


test "normalize", () ->
    equalsNorm = (x1, y1, x2, y2) ->
        n = new timber.Vector(x1, y1).normalize()
        e = new timber.Vector(x2, y2)
        return n.equals(e)

    ok(equalsNorm(1, 0, 1, 0), "x unit vector is unchanged")
    ok(equalsNorm(0, 1, 0, 1), "y unit vector is unchanged")
    ok(equalsNorm(3, 4, 0.6, 0.8), "pythagorarean unit vector is normalized")

test "normalize zero vector", () ->
    v = new timber.Vector(0, 0).normalize()
    equals(0, v.x, "x is zero")
    equals(0, v.y, "y is zero")


test "scale", () ->
    v = new timber.Vector(3, 4)
    equals(v.scale(0).length(), 0, "Scaling by zero produces the zero vector")
    equals(v.scale(1).length(), 5, "Scaling by one is idempotent")
    equals(v.scale(2).x, 6, "Scaling works")
    equals(v.scale(2).y, 8, "Scaling works")






module "timber.Environment"


test "Static elements don't move", () ->
    p = new timber.Point(5, 5)
    d = new timber.Vector(1, 0)
    s = 0
    e = new timber.Element(p, d, s)

    env = new timber.Environment()
    env.elapse(e, 100)
    ok(e.position.equals(p.copy()), "Position is unchanged")


test "Elements with speed & direction move", () ->
    p = new timber.Point(0, 0)
    d = new timber.Vector(1, 0)
    s = 1
    e = new timber.Element(p, d, s)

    env = new timber.Environment()
    env.elapse([e], 1000)

    equals(e.position.x, 1000, "Moves along x axis")
    equals(e.position.y, 0, "Moves along x axis")
    

