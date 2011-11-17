module "Point"

Point = wolf.Point

test "equals", () ->

    eq = (x1, y1, x2, y2) ->
        p1 = new wolf.Point(x1, y1)
        p2 = new wolf.Point(x2, y2)
        return p1.equals(p2)

    # Some equality tests.
    for c in [0, -1, 10, 20, 0.5, 0.7]
        ok( eq(c, c, c, c), "Point is equal: #{c}")

    # Some inequality tests.
    ok(not eq(1, 1, 1, 2), "Shouldn't be equal")
    ok(not eq(1, 2, 1.0, 1), "Shouldn't be equal")

test "add", () ->
    p = new wolf.Point(1, 2)
    v = new wolf.Vector(4, -5)

    p2 = p.add(v)

    ok(p2 instanceof wolf.Point, "adding vector and point produces a point")

    equals(p2.x, 5, "addition works")
    equals(p2.y, -3, "addition works")

test "toString", () ->
    equals("wolf.Point(10, -10)", new Point(10, -10).toString(), "alls well")
