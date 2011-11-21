#
# Tests for polygons.
#

module "Polygon"


test "setPosition", () ->
    t = new wolf.Polygon({vertices : [
        new wolf.Point(0, 0)
        new wolf.Point(0, 1)
        new wolf.Point(1, 1)
    ]})

    equals(t.x, 0, "initial x works")
    equals(t.y, 0, "initial y works")

    t.setPosition(new wolf.Point(1, 1))

    equals(t.x, 1, "x works after move")
    equals(t.y, 1, "y works after move")

    equals(t.vertices[2].x, 2, "other corner moved")
    equals(t.vertices[2].y, 2, "other corner moved")

