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
    t = polygon([0, 0], [0, 1], [1, 1])

    equals(t.x, 0, "initial x works")
    equals(t.y, 0, "initial y works")

    t.bind 'moved', (e) ->
        ok(true, 'callback was called')
        ok(e == t, "correct element was passed")

    t.setPosition(new wolf.Point(1, 1))

    equals(t.x, 1, "x works after move")
    equals(t.y, 1, "y works after move")

    equals(t.vertices[2].x, 2, "other corner moved")
    equals(t.vertices[2].y, 2, "other corner moved")

    # Assert setting to the same position leaves things untouched.
    t.setPosition(new wolf.Point(1, 1)) # Shouldn't trigger callback.

    equals(t.x, 1, "x works after move")
    equals(t.y, 1, "y works after move")

test "getCenterPoint", () ->
    # Assert that all vertices are updated on when moving.
    square = polygon([0, 0], [2, 0], [2, 2], [0, 2])
    sc = square.getCenter()
    equals(sc.x, 1, "center x of a square is correct")
    equals(sc.y, 1, "center y of a square is correct")


