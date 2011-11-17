#
# The code that has collision detection and resolution.
#


#= require logger
#= require math


class timber.Collision

    # Create a collision object.
    #
    # @param element1 {Object}
    # @param element2 {Object}
    constructor : (element1, element2) ->
        @element1 = element1
        @element2 = element2

    getElements : () ->
        return [@element1, @element2]

    # Return the collision's contact normal vector, relative
    # to the first element in the collision.
    #
    # @return {Object}
    getContactNormal : () ->
        return @getRelativeVelocity().normalize()
        
    # Return the seperating velocity of the two elements.
    getSeperatingVelocity : () ->
        return @getRelativeVelocity().dotProduct(@getContactNormal())

    # Return the relative velocity of the collision's elements.
    getRelativeVelocity : () ->
        return @element1.getVelocity().subtract(@element2.getVelocity())

    # Return the co-efficient of restitution for the given collision.
    getRestitutionCoefficient : () ->
        #FIXME: implement me
        return 0.5

    # Return the total mass of all elements in the collision.
    getMass : () ->
        @getElements().reduce((mass, e) ->
            mass += e.mass if 0 < e.mass
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
        @element1.applyImpulse(impulse1)

        impulse2 = impulse.scale(-1 * @element2.getInverseMass())
        @element2.applyImpulse(impulse2)


class timber.CollisionHandler

    # Create a collision handler.
    constructor : () ->
        @logger = new timber.Logger("timber.CollisionHandler")


    # Check the given elements for collisions, and update them accordingly.
    #
    # @param elements {Array} a list of elements to check for collisions.
    # @param milliseconds {Number} the time since the last collision check.
    elapse : (elements, milliseconds) ->
        collisions = this.detectCollisions(elements)
        (@resolveCollision(c) for c in collisions)

    # Return the collisions occuring between the given elements.
    #
    # @param elements {Array} the elements to check for collisions.
    # @return {Array} an array of collisions.
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
    #
    # @param e1 {Object} the first of the elements
    # @param e2 {Object} the second of the elements
    # @return {Object} or {null}
    detectCollision : (e1, e2) ->
        #FIXME: add an error of margin
        if e1.intersects(e2) then new timber.Collision(e1, e2) else null

    # Resolve the given collision.
    # 
    # @param {collision} the collision to resolve.
    resolveCollision : (collision) ->
        collision.applyForces()
      
