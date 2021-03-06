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

    one = new wolf.Rectangle({x:10, y:10, width:100, height:800})
    two = new wolf.Rectangle({x:50, y:0, width:50, height:50})
    ok(one.intersects(two), "overlapping rectangles intersect")
