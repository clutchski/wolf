#
# The code that has collision detection and resolution.
#

#= require wolf
#= require logger
#= require math


class wolf.Collision

    # Create a collision object.
    constructor : (element1, element2) ->
        @element1 = element1
        @element2 = element2
        @resolved = false

    getElements : () ->
        return [@element1, @element2]

    # Return the collision's contact normal vector, relative
    # to the first element in the collision.
    getContactNormal : () ->
        if @element2.isStatic()
            @element1.direction
        else
            @getRelativeVelocity().normalize()

    # Return the seperating velocity of the two elements.
    getSeperatingVelocity : () ->
        @getRelativeVelocity().dotProduct(@getContactNormal())

    # Return the relative velocity of the collision's elements.
    getRelativeVelocity : () ->
        @element1.getVelocity().subtract(@element2.getVelocity())

    # Return the co-efficient of restitution for the given collision.
    getRestitutionCoefficient : () ->
        @element1.restitution * @element2.restitution

    # Return the total mass of all elements in the collision.
    getMass : () ->
        @getElements().reduce((mass, e) ->
            mass += e.mass unless e.isStatic()
            return mass
        , 0)

    # Apply the forces of the collision to the elements.
    applyForces : () ->
        # Calculate the seperating velocity of the elements.
        seperatingVelocity = @getSeperatingVelocity()

        return if 0 > seperatingVelocity

        # Change the direction and scale by the elasticity of the elements.
        velocity = -seperatingVelocity * @getRestitutionCoefficient()

        magnitude = velocity * @getMass()
        impulse = @getContactNormal().scale(magnitude)

        # Apply the force of the collision to each element in proportion to
        # it's mass.
        impulse1 = impulse.scale(@element1.getInverseMass())
        @element1.setVelocity(impulse1)

        if not @element2.isStatic()
            impulse2 = impulse.scale(-1 * @element2.getInverseMass())
            @element2.setVelocity(impulse2)

    # Resolve the collision so as to prevent further handler.
    resolve : () ->
        @resolved = true

    # Return true if the collision has been resolved.
    isResolved : () ->
        return @resolved


class wolf.CollisionHandler

    # Create a collision handler.
    constructor : () ->

    # Check the given elements for collisions, and update them accordingly.
    elapse : (elements, milliseconds) ->
        collisions = this.detectCollisions(elements)
        (@resolveCollision(c) for c in collisions)

    # Return the collisions occuring between the given elements.
    detectCollisions : (elements) ->
        # FIXME: naive & inefficient solution.
        collisions = []
        for element, i in elements
            for other in elements[i+1..elements.length]
                c = @detectCollision(element, other)
                collisions.push(c) if c
        return collisions

    # Return a collision if the two elements are colliding, null
    # otherwise.
    detectCollision : (e1, e2) ->
        return null if (e1.isStatic() and e2.isStatic()) or not e1.intersects(e2)
        # If one of the elements is static, pass it second.
        [first, second] = if e1.isStatic() then [e2, e1] else [e1, e2]
        return new wolf.Collision(first, second)

    # Resolve the given collision.
    resolveCollision : (collision) ->
        e1 = collision.element1
        e2 = collision.element2

        e1.trigger('collided', collision, e2)
        e2.trigger('collided', collision, e1)
        if not collision.isResolved()
            collision.applyForces()
