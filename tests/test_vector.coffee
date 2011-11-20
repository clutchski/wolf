
module "Vector"


# A helper function to test "equality" between floating 
# point numbers. Obviously, not exact, but good enough
# for the girls we go out with.
almostEquals = (actual, expected, msg) ->
    diff =  Math.abs(actual - expected)
    ok(diff < 0.0000001, "#{msg} close enough: #{diff}")


test "length", () ->
    length = (x, y) ->
        return new wolf.Vector(x, y).getLength()
    equals(length(0, 0), 0, "No length is zero")
    equals(length(1, 0), 1, "x unit vector has length 1")
    equals(length(0, 1), 1, "y unit vector has length 1")
    equals(length(3, 4), 5, "Classic pythagorarean vector works")
    equals(length(-3, 4), 5, "Works with negative numbers")


test "normalize", () ->
    equalsNorm = (x1, y1, x2, y2) ->
        n = new wolf.Vector(x1, y1).normalize()
        e = new wolf.Vector(x2, y2)
        return n.equals(e)

    ok(equalsNorm(1, 0, 1, 0), "x unit vector is unchanged")
    ok(equalsNorm(0, 1, 0, 1), "y unit vector is unchanged")
    ok(equalsNorm(3, 4, 0.6, 0.8), "pythagorarean unit vector is normalized")

test "normalize zero vector", () ->
    v = new wolf.Vector(0, 0).normalize()
    equals(0, v.x, "x is zero")
    equals(0, v.y, "y is zero")

test "add", () ->
    x = new wolf.Vector(-1, -5)
    y = new wolf.Vector(1, 4)
    s = x.add(y)

    equals(s.x, 0, "x is right")
    equals(s.y, -1, "y is right")

test "subtract", () ->
    x = new wolf.Vector(-1, -5)
    y = new wolf.Vector(1, 4)
    s = x.subtract(y)

    equals(s.x, -2, "x is correct")
    equals(s.y, -9, "y is correct")

    
test "scale", () ->
    v = new wolf.Vector(3, 4)
    equals(v.scale(0).getLength(), 0, "Scaling by zero produces the zero vector")
    equals(v.scale(1).getLength(), 5, "Scaling by one is idempotent")
    equals(v.scale(2).x, 6, "Scaling works")
    equals(v.scale(2).y, 8, "Scaling works")

test "dot product", () ->

    v0 = new wolf.Vector(0, 0)
    v1 = new wolf.Vector(1, 1)
    v2 = new wolf.Vector(2, 2)

    for v in [v1, v2]
        equals(v0.dotProduct(v), 0, "Zero vector's dot product is zero")

    equals(v1.dotProduct(v1), 2, "Dot product is correct")
    equals(v1.dotProduct(v2), 4, "Dot product is correct")

test "project", () ->
    xAxis = new wolf.Vector(1, 0)
    yAxis = new wolf.Vector(0, 1)

    v1 = new wolf.Vector(3, 4)
    v2 = new wolf.Vector(1, 3)
    v3 = new wolf.Vector(-1, 2)

    # Assert project onto the axes works
    ok(v1.project(xAxis).equals(new wolf.Vector(3, 0)), "x axis projection")
    ok(v1.project(yAxis).equals(new wolf.Vector(0, 4)), "y axis projection")

    # Project a vector onto another.
    ok(v1.project(v1).equals(v1), "vector projected on itself")
    ok(v2.project(v3).equals(v3), "vector projection works")

test "rotate", () ->
    v = (x, y) ->
        new wolf.Vector(x, y)

    vequals = (v1, v2, msg) ->
        almostEquals(v1.x, v2.x, "x equal when #{msg}")
        almostEquals(v1.y, v2.y, "y equal when #{msg}")

    vequals(v(2, 3).rotate(0), v(2, 3), "rotated by zero")
    vequals(v(1, 0).rotate(90), v(0, 1), "rotated 90 degress")
    vequals(v(3, 4).rotate(180), v(-3, -4), "rotated 190 degress")
    vequals(v(0, 0).rotate(180), v(0, 0), "rotated 180 degress")

