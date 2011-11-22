module "Rectangle"

Rectangle = wolf.Rectangle

test "intersection", () ->
    # A shortcut test function to ensure intersection is always 
    # commutative.
    intersects = (tr1, tr2) ->
        return tr1.intersects(tr2) && tr2.intersects(tr1)

    r1 = new Rectangle({x:0, y:0, width:10, height:10})
    r2 = new Rectangle({x:0, y:0, width:100, height:100})
    r3 = new Rectangle({x:150, y:150, width:100, height:100})
    r4 = new Rectangle({x:50, y:50, width:100, height:100})
    r5 = new Rectangle({x:50, y:150,width:100, height:100})

    ok(intersects(r1, r2), "Containing rectangles intersect")
    ok(intersects(r2, r4), "Partially overlapping rectangles intersect")
    ok(not intersects(r1, r3), "Non overlapping don't intersect")
    ok(intersects(r3, r4), "One point adjacent rectangles intersect")

test "containing intersection", () ->
    one = new wolf.Rectangle({x:10, y:10, width:100, height:800})
    two = new wolf.Rectangle({x:50, y:0, width:50, height:50})
    ok(one.intersects(two), "overlapping rectangles intersect")

test "getBoundingBox", () ->
    r1 = new Rectangle({x:0, y:0, width:10, height:10})

    # Assert the bounding box is all good.
    aabb = r1.getBoundingBox()
    equals(aabb.length, 4, "box has 4 points")
    ok(aabb[0].equals(new wolf.Point(0, 0)), "first point is equal")
    ok(aabb[2].equals(new wolf.Point(10, 10)), "last point is equal")

    # Move the shape and assert the bounding box moves along.
    r1.setPosition(new wolf.Point(10, 10))
    aabb = r1.getBoundingBox()
    equals(aabb.length, 4, "box has 4 points")
    ok(aabb[0].equals(new wolf.Point(10, 10)), "first point is equal")
    ok(aabb[2].equals(new wolf.Point(20, 20)), "last point is equal")

