#
# Elements are the entities drawn on the canvas.
#


#= require events
#= require math


class wolf.Element

    # Create an element. The constructor takes a single argument which is a map
    # of options. Here are the accepted parameters:
    #
    #   x: The x co-ordinate. Defaults to zero.
    #   y: The y co-ordinate. Defaults to zero.
    #   direction: A direction vector. Defaults to (0, 0)
    #   speed: The element's initial speed. Defaults to zero.
    #   mass: The element's mass. Defaults to 1000.
    #   dragCoefficient: The element's drag co-efficient. Defaults to 0.7.
    #   visible: The element's visiblity status. Defaults to true.
    constructor : (opts = {}) ->

        # Set options with potentially default values.
        defaults =
            x: 0
            y: 0
            speed: 0
            mass: 1000
            direction: new wolf.Vector(0, 0)
            dragCoefficient: 0.7
            visible: true
            id: wolf.getUniqueId()
        ((@[k] = v) for k, v of wolf.defaults(opts, defaults))

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

    # Apply an impulse force to the element.
    applyImpulse : (impulse) ->
        velocity = @getVelocity().add(impulse)
        @direction = velocity.normalize()
        @speed = velocity.getLength()

    # Apply the given force to the element for the given number of
    # milliseconds.
    applyForce : (force, milliseconds) ->
        # Calculate the effects of the force.
        acceleration = force.scale(@getInverseMass())
        velocity = @getVelocity().add(acceleration.scale(milliseconds))
        displacement = velocity.scale(milliseconds)
        position = @getPosition().add(displacement)

        # Update the element's state.
        @setPosition(position)
        @speed = velocity.getLength()
        @direction = velocity.normalize() unless velocity.isZeroVector()

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
