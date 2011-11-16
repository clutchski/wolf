#
# Timber canvas tests.
#


# Shortcuts

Vector = timber.Vector
Rectangle = timber.Rectangle
Position = timber.Position
Point = timber.Point



module "timber"

test "intervalIntersects", () ->

    ii = timber.intervalIntersects

    ok(not ii([0, 1], [2, 5]), "Doesn't intersect")
    ok(ii([0, 1], [1, 2]), "Adjacent intersect")
    ok(ii([0, 2], [1, 2]), "Overlapping intersect")
    ok(ii([1, 2], [0, 2]), "Overlapping intersect both ways")
    ok(ii([1, 10], [5, 6]),"Containing intervals intersect")
    ok(ii([0, 2], [0, 2]),"Identical intervals intersect")

module "timber.Rectangle"

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
  one = new timber.Rectangle({x:10, y:10, width:100, height:800})
  two = new timber.Rectangle({x:50, y:0, width:50, height:50})
  ok(one.intersects(two), "overlapping rectangles intersect")


