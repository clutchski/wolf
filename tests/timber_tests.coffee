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


module "timber.Element"

test "mass", () ->
    e = new timber.Element()
    ok(e.mass, "mass has a default value")
    e.mass = 10
    equals(e.mass, 10, "mass is settable")
    equals(e.getInverseMass(), 1/10, "inverse mass works")



module "timber.Engine"

test "No elements", () ->
    c = new timber.Engine("test-canvas")
    equals(c.elements.length, 0, "New canvas has no elements")

test "Add elements", () ->
    c = new timber.Engine("test-canvas")
    c.add(new timber.Element())
    equals(c.elements.length, 1, "Element was added")

    c.add(new timber.Element(), new timber.Element())
    equals(c.elements.length, 3, "variadic add works")


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

test "add", () ->
    p = new timber.Point(1, 2)
    v = new timber.Vector(4, -5)

    p2 = p.add(v)

    ok(p2 instanceof timber.Point, "adding vector and point produces a point")

    equals(p2.x, 5, "addition works")
    equals(p2.y, -3, "addition works")

test "toString", () ->
    equals("timber.Point(10, -10)", new Point(10, -10).toString(), "alls well")


module "timber.Vector"


test "length", () ->
    length = (x, y) ->
        return new timber.Vector(x, y).getLength()
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

test "add", () ->
    x = new timber.Vector(-1, -5)
    y = new timber.Vector(1, 4)
    s = x.add(y)

    equals(s.x, 0, "x is right")
    equals(s.y, -1, "y is right")

test "subtract", () ->
    x = new timber.Vector(-1, -5)
    y = new timber.Vector(1, 4)
    s = x.subtract(y)

    equals(s.x, -2, "x is correct")
    equals(s.y, -9, "y is correct")

    
test "scale", () ->
    v = new timber.Vector(3, 4)
    equals(v.scale(0).getLength(), 0, "Scaling by zero produces the zero vector")
    equals(v.scale(1).getLength(), 5, "Scaling by one is idempotent")
    equals(v.scale(2).x, 6, "Scaling works")
    equals(v.scale(2).y, 8, "Scaling works")

test "dot product", () ->

    v0 = new timber.Vector(0, 0)
    v1 = new timber.Vector(1, 1)
    v2 = new timber.Vector(2, 2)

    for v in [v1, v2]
        equals(v0.dotProduct(v), 0, "Zero vector's dot product is zero")

    equals(v1.dotProduct(v1), 2, "Dot product is correct")
    equals(v1.dotProduct(v2), 4, "Dot product is correct")

test "project", () ->
    xAxis = new timber.Vector(1, 0)
    yAxis = new timber.Vector(0, 1)

    v1 = new timber.Vector(3, 4)
    v2 = new timber.Vector(1, 3)
    v3 = new timber.Vector(-1, 2)

    # Assert project onto the axes works
    ok(v1.project(xAxis).equals(new timber.Vector(3, 0)), "x axis projection")
    ok(v1.project(yAxis).equals(new timber.Vector(0, 4)), "y axis projection")

    # Project a vector onto another.
    ok(v1.project(v1).equals(v1), "vector projected on itself")
    ok(v2.project(v3).equals(v3), "vector projection works")


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
    env.gravitationalConstant = 0
    env.density = 0

    env.elapse([e], 1000)

    equals(e.position.x, 1000, "Moves along x axis")
    equals(e.position.y, 0, "Moves along x axis")

test "gravity", () ->
    ok false, "add tests for gravity"

test "drag", () ->
    ok false, "add tests for drag"



module "timber.Rectangle"

test "intersection", () ->
    # A shortcut test function to ensure intersection is always 
    # commutative.
    intersects = (tr1, tr2) ->
        return tr1.intersects(tr2) && tr2.intersects(tr1)

    s = 0
    d = new Vector(1, 1)

    r1 = new Rectangle(new Point(0, 0), s, d, 10, 10)
    r2 = new Rectangle(new Point(0, 0), s, d, 100, 100)
    r3 = new Rectangle(new Point(150, 150), s, d, 100, 100)
    r4 = new Rectangle(new Point(50, 50), s, d, 100, 100)
    r5 = new Rectangle(new Point(50, 150), s, d, 100, 100)






    ok(intersects(r1, r2), "Containing rectangles intersect")
    ok(intersects(r2, r4), "Partially overlapping rectangles intersect")
    ok(not intersects(r1, r3), "Non overlapping don't intersect")
    ok(intersects(r3, r4), "One point adjacent rectangles intersect")

test "containing intersection", () ->
  d = new timber.Vector(1, -1)

  one = new timber.Rectangle(new Point(10, 10), 0, d, 10, 800)
  two = new timber.Rectangle(new Point(50, 0), 0, d, 50, 50)

  ok(one.intersects(two), "overlapping rectangles intersect")


module "timber.CollisionHandler"

test "detectCollisions", () ->
    ch = new timber.CollisionHandler()

    s = 0
    d = new Vector(1, 1)

    r1 = new Rectangle(new Point(0, 0), s, d, 10, 10)
    r2 = new Rectangle(new Point(0, 0), s, d, 100, 100)
    r3 = new Rectangle(new Point(150, 150), s, d, 100, 100)
    r4 = new Rectangle(new Point(50, 50), s, d, 100, 100)
    r5 = new Rectangle(new Point(50, 150), s, d, 100, 100)
    r6 = new Rectangle(new Point(500, 500), s, d, 100, 100)

    equals(ch.detectCollisions([]).length, 0, "no elements")
    equals(ch.detectCollisions([r1]).length, 0, "one element")
    equals(ch.detectCollisions([r1, r3, r6]).length, 0, "no collisions")

    collisions = ch.detectCollisions([r1, r2])
    equals(collisions.length, 1, "found one collision")

    collisions = ch.detectCollisions([r1, r2, r3, r4, r5, r6])
    equals(collisions.length, 5, "found five collisions")

test "detectCollision", () ->

    s = 0
    d = new Vector(1, 1)

    r1 = new Rectangle(new Point(0, 0), s, d, 10, 10)
    r2 = new Rectangle(new Point(0, 0), s, d, 100, 100)
    r3 = new Rectangle(new Point(20, 20), s, d, 100, 100)

    ch = new timber.CollisionHandler()

    ok(ch.detectCollision(r1, r2), "collision")
    ok(not ch.detectCollision(r1, r3), "no collision")

test "resolveCollision", () ->

    s = 0
    d = new Vector(1, 1)
    p1 = new Point(10, 10)
    p2 = new Point(20, 20)

    r1 = new Rectangle(p1, d, s, 50, 50)
    r2 = new Rectangle(p1, d, s, 50, 50)

    ch = new timber.CollisionHandler()
    
    c = ch.detectCollision(r1, r2)
    ok(c, "Ensure our shapes intersect")

    ch.resolveCollision(c)
    ok(not ch.detectCollision(r1, r2), "the shapes no longer intersect")