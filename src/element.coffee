#
# Elements are the entities drawn on the canvas.
#


#= require math


# 
#
# An abstract base class for any drawable thing.
#
class timber.Element

    # Create an element.
    #
    # @param position {Object} a point representing the position
    # @param direction {Object} a unit vector representing direction
    # @param speed {Object} the speed in pixels per millisecond
    constructor : (position, direction, speed) ->
        
        #FIXME: change this class to have sane default arguments, like 0 speed,
        #position at the origin, etc.

        @position = position
        @direction = direction
        @speed = speed
        @mass = 1000
        @area = 1
        @dragCoefficient =  0.7

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

    constructor : (position, direction, speed, radius) ->
        super(position, direction, speed)
        @radius = radius

    render : (context) ->
        context.beginPath()
        context.arc(@position.x, @position.y, @radius, 0, Math.PI *2)
        context.stroke()

    getAxisAlignedBoundingBox : () ->
        # FIXME: need non-axis aligned collisions for this

        yt = @position.y - @radius
        yb = @position.y + @radius
        xl = @position.x - @radius
        xr = @position.x + @radius

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


    # Create a rectangle element.
    #
    # @param position {Object} the top left corner of the rectangle.
    constructor : (position, direction, speed, height, width) ->
        super(position, direction, speed)
        @height = height
        @width = width

    getCorners : () ->
        # Find the co-ordinates of the rectangle's corners.
        x1 = @position.x
        y1 = @position.y
        x2 = @position.x + @width
        y2 = @position.y + @height
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
        context.stroke()

    getAxisAlignedBoundingBox : () ->
        return this.getCorners()

