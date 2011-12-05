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
        ((@[k] = v) for k, v of wolf.defaults(opts, defaults))

        # A list of of forces that will be applied to the element on the
        # next iteration.
        @forces = []

    # Return the element's position.
    getPosition : () ->
        return new wolf.Point(@x, @y)

    # Set the element's position. This will fire the event 'moved' unless
    # silent is set to true.
    setPosition : (point, silent=false) ->
        if not @getPosition().equals(point)
            @x = point.x
            @y = point.y
            @trigger('moved', this) if not silent
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

    # Return true if this element intersects with the other
    # element, false otherwise.
    intersects : (other) ->
        bb = this.getBoundingBox()
        ob = other.getBoundingBox()

        [ttl, ttr, tbl, tbr] = bb # this top left, this top right, etc.
        [otl, otr, obl, obr] = ob # other top left, other top, right, etc.

        # Find axis projection intervals.
        ty = [ttl.y, tbl.y]
        oy = [otl.y, obl.y]
        tx = [ttl.x, ttr.x]
        ox = [otl.x, otr.x]

        ii = wolf.intervalIntersects
        return ii(ty, oy) and ii(ox, tx)

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

    # Rotate the element counter-clockwise by the given number of degrees
    # about it's center.
    rotate : (degrees) ->
        throw new Error("Not Implemented error")

# Mix events into the element class.
wolf.extend(wolf.Element::, wolf.Events)
