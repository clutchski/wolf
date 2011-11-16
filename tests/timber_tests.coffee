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


module "timber.Canvas"


test "Non-existant canvas", () ->
    raises(() ->
        c = new timber.Canvas("a-non-existant-id")
    , "A canvas that doesn't exist should throw an error")

module "timber.Environment"


test "Static elements don't move", () ->
    d = new timber.Vector(1, 0)
    e = new timber.Rectangle({x:5, y:5, direction:d, speed:0})

    env = new timber.Environment()
    env.elapse(e, 100)
    equals(e.x, 5, "x is unchanged")
    equals(e.y, 5, "y is unchanged")


test "Elements with speed & direction move", () ->
    d = new timber.Vector(1, 0)
    e = new timber.Rectangle({x:0, y:0, speed:1, direction:d})

    env = new timber.Environment()
    env.gravitationalConstant = 0
    env.density = 0

    env.elapse([e], 1000)

    equals(e.x, 1000, "Moves along x axis")
    equals(e.y, 0, "Moves along x axis")


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


module "timber.CollisionHandler"

test "detectCollisions", () ->
    ch = new timber.CollisionHandler()

    r1 = new Rectangle({x:0,    y:0,    width:10,  height:10})
    r2 = new Rectangle({x:0,    y:0,    width:100, height:100})
    r3 = new Rectangle({x:150,  y:150,  width:100, height:100})
    r4 = new Rectangle({x:50,   y:50,   width:100, height:100})
    r5 = new Rectangle({x:50,   y:150,  width:100, height:100})
    r6 = new Rectangle({x:500,  y:500,  width:100, height:100})

    equals(ch.detectCollisions([]).length, 0, "no elements")
    equals(ch.detectCollisions([r1]).length, 0, "one element")
    equals(ch.detectCollisions([r1, r3, r6]).length, 0, "no collisions")

    collisions = ch.detectCollisions([r1, r2])
    equals(collisions.length, 1, "found one collision")

    collisions = ch.detectCollisions([r1, r2, r3, r4, r5, r6])
    equals(collisions.length, 5, "found five collisions")

test "detectCollision", () ->
    r1 = new Rectangle({x:0, y:0, width:10, height: 10})
    r2 = new Rectangle({x:0, y:0, width:100, height: 100})
    r3 = new Rectangle({x:20, y:20, width:100, height: 100})

    ch = new timber.CollisionHandler()

    ok(ch.detectCollision(r1, r2), "collision")
    ok(not ch.detectCollision(r1, r3), "no collision")
