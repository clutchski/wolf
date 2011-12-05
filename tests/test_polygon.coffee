#
# Tests for polygons.
#

module "Polygon"


#
# Test helpers.
#

points = (coords...) ->
    return (new wolf.Point(c[0], c[1]) for c in coords)

polygon = (position, vcoords...) ->
    return new wolf.Polygon({
        x:position[0]
        y:position[1]
        vertices : points(vcoords)
    })

Point = wolf.Point

#
# Tests.
#

test "setPosition", () ->

    t = new wolf.Polygon({
        x: 0,
        y: 0,
        vertices: points([-1, -1], [-1, 1], [1, 1], [1, -1])
    })

    # assert initial state of vertices is all good.
    equals(t.x, 0, "initial x works")
    equals(t.y, 0, "initial y works")
    ok(new Point(1, 1).equals(t.getVertices()[2]), "Relative vertices work")
    ok(new Point(1, 1).equals(t.getAbsoluteVertices()[2]), "Absolute vertices work")
    ok(new Point(1, 1).equals(t.getBoundingBox()[2]), "Bounding box works")

    # Assert that all vertices are updated on when moving.
    t.setPosition(new Point(2, 2))
    equals(t.x, 2, "x works after move")
    equals(t.y, 2, "y works after move")
    ok(new Point(1, 1).equals(t.getVertices()[2]), "Relative vertices didn't move")
    ok(new Point(3, 3).equals(t.getAbsoluteVertices()[2]), "Absolute vertice moved")
    ok(new Point(3, 3).equals(t.getBoundingBox()[2]), "Bounding box moves")


test "rotate", () ->

    almostEqual = (x, y, msg) ->
        ok(wolf.almostEqual(x, y, 0.00001), "#{msg} #{x} #{y} almost equal")

    # Rotate a square.
    s = new wolf.Polygon({
        x:1,
        y:1,
        vertices: points([-1, -1], [-1, 1], [1, 1], [1, -1])
    })
    s.rotate(90)

    # Assert all is well.
    equals(s.x, 1, "center did not move")
    equals(s.y, 1, "center did not move")

    # Expected.
    expected = [[-2, 0], [0, -2], [-2, 0], [0, 2]]
    actual = ([v.x, v.y] for v in s.getAbsoluteVertices())
    for i in [0..expected.length-1]
        e = expected[i]
        a = actual[i]
        for j in [0..1]
            almostEqual(e[j], a[j], "vertex #{i}.#{j}")
