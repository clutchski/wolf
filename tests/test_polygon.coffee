#
# Tests for polygons.
#

module "Polygon"


# A factory function for points.
polygon = (points...) ->
    vertices = (new wolf.Point(p[0], p[1]) for p in points)
    return new wolf.Polygon({vertices : vertices})

test "setPosition", 10, () ->

    # Assert that all vertices are updated on when moving.
    t = polygon([1, 1], [1, 2], [2, 2])

    equals(t.x, 1, "initial x works")
    equals(t.y, 1, "initial y works")

    t.bind 'moved', (e) ->
        ok(true, 'callback was called')
        ok(e == t, "correct element was passed")

    t.setPosition(new wolf.Point(2, 2))

    equals(t.x, 2, "x works after move")
    equals(t.y, 2, "y works after move")

    equals(t.vertices[2].x, 3, "other corner moved")
    equals(t.vertices[2].y, 3, "other corner moved")

    # Assert setting to the same position leaves things untouched.
    t.setPosition(new wolf.Point(2, 2)) # Shouldn't trigger callback.

    equals(t.x, 2, "x works after move")
    equals(t.y, 2, "y works after move")

test "getCenterPoint", () ->
    # Assert that all vertices are updated on when moving.
    square = polygon([0, 0], [2, 0], [2, 2], [0, 2])
    sc = square.getCenter()
    equals(sc.x, 1, "center x of a square is correct")
    equals(sc.y, 1, "center y of a square is correct")

test "rotate", () ->
    # Rotate a square.
    square = polygon([1, 1], [-1, 1], [-1, -1], [1, -1])
    square.rotate(90)

    almostEqual = (x, y, msg) ->
        ok(x - y < 0.000001, "#{msg} almost equal")

    # Assert the vertices are as expected.
    expected = [[-1, 1], [-1, -1], [1, -1], [1, 1]]
    actual = ([v.x, v.y] for v in square.vertices)
    for i in [0..expected.length-1]
        e = expected[i]
        a = actual[i]
        for j in [0..1]
            almostEqual(e[j], a[j], "vertex #{i}.#{j} rotation")
    almostEqual(square.getPosition().x, -1, "x pos")
    almostEqual(square.getPosition().y, 1, "y pos")


