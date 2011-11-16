#
# Tests for the Element class.
#


module "Element"


class TestElement extends timber.Element

    @key = 'TestElement'


test "mass", () ->
    e = new TestElement()
    ok(e.mass, "mass has a default value")
    e.mass = 10
    equals(e.mass, 10, "mass is settable")
    equals(e.getInverseMass(), 1/10, "inverse mass works")

test "destroy", 2, () ->
    e = new TestElement()
    e.bind 'destroyed', (actual) ->
        ok(true, 'destroyed callback was called')
        equals(actual, e, "destroyed passes the element as an argument")
    e.destroy()

test "applyForce", () ->

    # An zero force on a zero vector doesn't move.
    d = new timber.Vector(1, 0)
    staticElement = new TestElement({x:5, y:5, direction:d, speed:0})
    staticElement.applyForce(new timber.Vector(0, 0), 1000)
    equals(staticElement.x, 5, "x is unchanged")
    equals(staticElement.y, 5, "y is unchanged")

    # Applying a zero force vector to a dynamic element does not
    # alter it's course.
    dynamicElement = new TestElement({x:0, y:0, speed:1, direction:d})
    dynamicElement.applyForce(new timber.Vector(0, 0), 1000)
    equals(dynamicElement.x, 1000, "x is as expected")
    equals(dynamicElement.y, 0, "y is as expected")

    # Applying a non-zero vector to a dynamic element changes it's course.
    dynamicElement.applyForce(new timber.Vector(-2, 0), 1000)
    equals(dynamicElement.x, 0, "x has returned to origin")
    equals(dynamicElement.y, 0, "y is as expected")

