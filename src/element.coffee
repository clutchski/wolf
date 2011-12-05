#
# Elements are the entities drawn on the canvas.
#


#= require wolf
#= require events
#= require math


class wolf.Element

    # Create an element. The constructor takes a single argument which is a map
    # of options.
    constructor : (opts = {}) ->
        # Set options with potentially default values.
        defaults =
            x: 0
            y: 0
            speed: 0
            mass: 1000
            direction: new wolf.Vector(0, 0)
            dragCoefficient: 0.7
            restitution: 0.5
            static: false
            angle: 0
        ((@[k] = v) for k, v of wolf.defaults(opts, defaults))

        # A list of of forces that will be applied to the element on the
        # next step of the time simulation.
        @forces = []

    # Return the element's position.
    getPosition : () ->
        return new wolf.Point(@x, @y)

    # Set the element's position.
    setPosition : (point) ->
        @x = point.x
        @y = point.y
        return this

    # Return the element's velocity.
    getVelocity : () ->
        return @direction.normalize().scale(@speed)

    # Set the element's velocity.
    setVelocity : (velocity) ->
        @speed = velocity.getLength()
        @direction = velocity.normalize() unless velocity.isZeroVector()

    # Apply an impulse force to the element.
    applyImpulse : (impulse) ->
        return this if @isStatic()
        velocity = @getVelocity().add(impulse)
        @setVelocity(velocity)
        return this

    # Apply the given force to the element for the given number of
    # milliseconds.
    applyForce : (force, milliseconds) ->
        return this if @isStatic()

        # Calculate the effects of the force.
        acceleration = force.scale(@getInverseMass())
        velocity = @getVelocity().add(acceleration.scale(milliseconds))
        displacement = velocity.scale(milliseconds)
        position = @getPosition().add(displacement)

        # Update the element's state.
        @setPosition(position)
        @setVelocity(velocity)
        return this

    # Apply the given forces to the element on the next step of the simulation.
    addForces : (forces...) ->
        (@forces.push(f) for f in forces)
        this

    # Update the state of the element with the effects of the given
    # number of milliseconds elapsing.
    elapse : (milliseconds, iteration) ->
        # Reduce all the forces into a single force.
        resultant = @forces.reduce (t, s) -> t.add(s)
        @applyForce(resultant, milliseconds)
        @forces = []
        return this

    # Return true if this element intersects with the other
    # element, false otherwise.
    intersects : (other) ->
        [tx, ty] = @getAxisProjections()
        [ox, oy] = other.getAxisProjections()
        ii = wolf.intervalIntersects
        return ii(ty, oy) and ii(ox, tx)

    # Return the axis projections of the element's bounding box.
    getAxisProjections : () ->
        bb = @getBoundingBox()
        first = bb[0]
        # FIXME: this is an insanely slow. Memoize? Rely on ordering
        # so we don't have to sort or search?
        maxx = minx = first.x
        maxy = miny = first.y
        for p in bb[1..bb.length]
            maxx = Math.max(maxx, p.x)
            minx = Math.min(minx, p.x)
            maxy = Math.max(maxy, p.y)
            miny = Math.min(miny, p.y)
        return [[minx, maxx], [miny, maxy]]

    # Return the element's inverse mass.
    getInverseMass : () ->
        return 1/@mass

    # Destroy the element. This will fire the 'destroyed' event and then
    # unbind all other event callbacks that are bound.
    destroy : () ->
        @trigger('destroyed', @)
        @unbind()
        return this

    # Return true if the element is static.
    isStatic : () ->
        return @static

    # Rotate the element counter-clockwise by the given number of degrees
    # about it's center.
    rotate : (degrees) ->
        @angle = (@angle + degrees) % 360
        this

    # Render the element on the given canvas context.
    render : (context) ->
        throw new Error("Not Implemented error")

    # Return the center point of the element.
    getCenter : (context) ->
        throw new Error("Not Implemented error")

    # Return an array of points that when joined create a convex polygon
    # that fully enclosed the element.
    getBoundingBox : () ->
        throw new Error("Not Implemented error")

# Mix events into the element class.
wolf.extend(wolf.Element::, wolf.Events)
