#
# Elements are the entities drawn on the canvas.
#


#= require math


class timber.Element

    @key : null

    # Create an element. The constructor takes a single argument which is a map
    # of options. Here are the accepted parameters:
    #
    #   x: The x co-ordinate. Defaults to zero.
    #   y: The y co-ordinate. Defaults to zero.
    #   direction: A direction vector. Defaults to (0, 0)
    #   speed: The element's initial speed. Defaults to zero.
    #   mass: The element's mass. Defaults to 1000.
    #   dragCoefficient: The element's drag co-efficient. Defaults to 0.7.
    constructor : (opts = {}) ->
        # Set default variables if necessary.
        @x = opts.x or 0
        @y = opts.y or 0
        @speed = opts.speed or 0
        @mass = opts.mass or 1000
        @direction = opts.direction or new timber.Vector(0, 0)
        @dragCoefficient = if opts.dragCoefficient? then opts.dragCoefficient else 0.7

        # Ensure the Element class has a unique key, used for registering
        # class collision events.
        if not @constructor.key
            throw new Error("Class missing required property 'key'")

    # Return the element's position.
    getPosition : () ->
        return new timber.Point(@x, @y)

    # Set the element's position.
    setPosition : (point) ->
        @x = point.x
        @y = point.y

    # Return the element's velocity.
    #
    # @return {Object} the velocity vector.
    getVelocity : () ->
        return @direction.normalize().scale(@speed)

    # Render the element on the given canvas context.
    #
    # @param context {Object} the HTML5 canvas context
    render : (context) ->
        throw new Error("Not Implemented error")

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
        @direction = velocity.normalize()


    # Return true if this element intersects with the other
    # element, false otherwise.
    #
    # @param other {Object} the other element
    # @return {Boolean}
    intersects : (other) ->
        bb = this.getAxisAlignedBoundingBox()
        ob = other.getAxisAlignedBoundingBox()

        [ttl, ttr, tbl, tbr] = bb # this top left, this top right, etc.
        [otl, otr, obl, obr] = ob # other top left, other top, right, etc.

        # Find axis projection intervals.
        ty = [ttl.y, tbl.y]
        oy = [otl.y, obl.y]
        tx = [ttl.x, ttr.x]
        ox = [otl.x, otr.x]

        ii = timber.intervalIntersects
        return ii(ty, oy) and ii(ox, tx)


    # Return an array of points that when joined create a convex polygon
    # that fully enclosed the element.
    #
    # @return {Array} an array of points
    getAxisAlignedBoundingBox : () ->
        # FIXME: not sure if an array of points is the best way to represent
        # this, though it might be the easiest way to extend to non-axis
        # aligned shapes.
        throw new Error("Not Implemented error")

    # Return the element's inverse mass.
    #
    # @return {Number}
    getInverseMass : () ->
        return 1/@mass



#
# A circle element.
#

class timber.Circle extends timber.Element

    @key : "timber.Circle",

    constructor : (opts) ->
        super(opts)
        @radius = opts.radius

    render : (context) ->
        context.beginPath()
        context.arc(@x, @y, @radius, 0, Math.PI *2)
        context.fill()

    getAxisAlignedBoundingBox : () ->
        # FIXME: need non-axis aligned collisions for this

        yt = @y - @radius
        yb = @y + @radius
        xl = @x - @radius
        xr = @x + @radius

        return [
            new timber.Point(xl, yt)
            new timber.Point(xr, yt)
            new timber.Point(xr, yb)
            new timber.Point(xl, yb)
        ]


#
# A rectangle element.
#

class timber.Rectangle extends timber.Element

    @key : "timber.Rectangle",

    # Create a rectangle element. Rectangles take the same standard parameters
    # as elements, along with two additional paramters, width and height.
    constructor : (opts = {}) ->
        super(opts)
        @height = opts.height
        @width = opts.width

    getCorners : () ->
        # Find the co-ordinates of the rectangle's corners.
        x1 = @x
        y1 = @y
        x2 = @x + @width
        y2 = @y + @height
        return [
            new timber.Point(x1, y1)
            new timber.Point(x2, y1),
            new timber.Point(x2, y2),
            new timber.Point(x1, y2)
        ]

    render : (context) ->
        corners = this.getCorners()
        context.beginPath()
        first = corners.shift()
        context.moveTo(first.x, first.y)
        corners.push(first)
        for c in corners
            context.lineTo(c.x, c.y)
        context.fill()

    getAxisAlignedBoundingBox : () ->
        return this.getCorners()

