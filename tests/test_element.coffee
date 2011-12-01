#
# Tests for the Element class.
#


module "Element"


test "mass", () ->
    e = new wolf.Element()
    ok(e.mass, "mass has a default value")
    e.mass = 10
    equals(e.mass, 10, "mass is settable")
    equals(e.getInverseMass(), 1/10, "inverse mass works")

test "destroy", 2, () ->
    e = new wolf.Element()

    # Add a callback that should get called on destruction.
    e.bind 'destroyed', (actual) ->
        ok(true, 'destroyed callback was called')
        equals(actual, e, "destroyed passes the element as an argument")

    # Add a callback that should be unbound when the element
    # is destroyed.
    e.bind 'another', () ->
        ok(false, "This callback should never be called")

    e.destroy().trigger('another')


test "applyForce", () ->
    # An zero force on a zero vector doesn't move.
    d = new wolf.Vector(1, 0)
    staticElement = new wolf.Element({x:5, y:5, direction:d, speed:0})
    staticElement.applyForce(new wolf.Vector(0, 0), 1000)
    equals(staticElement.x, 5, "x is unchanged")
    equals(staticElement.y, 5, "y is unchanged")

    # Applying a zero force vector to a dynamic element does not
    # alter it's course.
    dynamicElement = new wolf.Element({x:0, y:0, speed:1, direction:d})
    dynamicElement.applyForce(new wolf.Vector(0, 0), 1000)
    equals(dynamicElement.x, 1000, "x is as expected")
    equals(dynamicElement.y, 0, "y is as expected")

    # Applying a non-zero vector to a dynamic element changes it's course.
    dynamicElement.applyForce(new wolf.Vector(-2, 0), 1000)
    equals(dynamicElement.x, 0, "x has returned to origin")
    equals(dynamicElement.y, 0, "y is as expected")

test "applyImpulse", () ->
    e = new wolf.Element()
    ok(e.getVelocity().equals(new wolf.Vector(0, 0)), "element is static")

    # Apply impulse to a static element.
    impulse = new wolf.Vector(1, 0)
    e.applyImpulse(impulse)
    ok(e.getVelocity().equals(impulse), "impulse applied to static object")

    # Apply impulse to a moving element.
    e.applyImpulse(impulse)
    ok(e.getVelocity().equals(impulse.scale(2)), "impulse applied to moving object")

    # Applying a zero force has no effect.
    v = e.getVelocity()
    e.applyImpulse(new wolf.Vector(0, 0))
    ok(e.getVelocity().equals(v), "velocity is unchanged")

test "setPosition", 4, () ->
    e = new wolf.Element({x:0, y:0})
    e.bind 'moved', (a) ->
        equals(e, a, 'move event fired')
        equals(e.x, 1, 'correct x')

    e.setPosition(e.getPosition().copy()) # shouldn't fire event
    e.setPosition(new wolf.Point(1, 1)) # should fire event
    equals(e.x, 1, "x is correct")
    equals(e.y, 1, "y is correct")

    e.setPosition(new wolf.Point(10, 10), silent=true) # Shouldn't fire event.
