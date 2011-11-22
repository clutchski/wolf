#
# Elements are the entities drawn on the canvas.
#


#= require events
#= require math


class wolf.Element

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
        ((@[k] = v) for k, v of wolf.defaults(opts, defaults))

        # Ensure the Element class has a unique key, used for registering
        # class collision events.
        if not @constructor.key
            throw new Error("Class missing required property 'key'")

        # An the object a unique id.
        @id = if opts.id? then opts.id else wolf.getUniqueId(@constructor.key)


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
        @direction = velocity.normalize()

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



#
# A class representing an arbitrary convex polygon.
#

class wolf.Polygon extends wolf.Element
    
    @key : 'wolf.Polygon'

    # Create a polygon. The x and y co-ordinates are taken to the
    # first point.
    constructor : (opts={}) ->
        # Construct the polygon.
        super(opts)
        @setVertices(@vertices, silent=true)
 
    # Set the position of the polygon to the given point.
    setPosition : (point, silent=false) ->
        # Calculate the distance the point has moved.
        delta = point.subtract(@getPosition())
        return @setVertices((v.add(delta) for v in @vertices), silent)

    render : (context) ->
        [first, rest...] = @vertices
        context.beginPath()
        context.moveTo(first.x, first.y)
        (context.lineTo(v.x, v.y) for v in rest)
        context.lineTo(first.x, first.y)
        context.fill()
        return this

    setVertices : (vertices, silent=false) ->
        if not vertices? or vertices.length < 3
            throw new Error("minimum three vertices")
        position = vertices[0]
        changed = not @getPosition().equals(position)
        @vertices = vertices
        @x = position.x
        @y = position.y
        @trigger('moved', @) if changed and not silent
        this

    getCenter : ()  ->
        # The co-ordinates of the center point are the 
        # averages of the polygon's vertices.
        c = @vertices.reduce((p, v) ->
            return p.add(v)
        , new wolf.Point(0, 0))

        c.x = c.x / @vertices.length
        c.y = c.y / @vertices.length
        return c

    rotate : (degrees, silent=false) ->
        return this if not degrees
        c = @getCenter()
        rotatedVertices = for v in @vertices
            v.subtract(c).toVector().rotate(degrees).getEndPoint().add(c)
        return @setVertices(rotatedVertices, silent)

#
# A rectangle element.
#

class wolf.Rectangle extends wolf.Polygon

    @key : "wolf.Rectangle",

    # Create a rectangle element. Rectangles take the same standard parameters
    # as elements, along with two additional paramters, width and height.
    constructor : (opts = {}) ->
        @height = opts.height
        @width = opts.width
        @x = opts.x
        @y = opts.y

        opts.vertices = [
            new wolf.Point(@x, @y)
            new wolf.Point(@x + @width, @y)
            new wolf.Point(@x + @width, @y + @height)
            new wolf.Point(@x, @y + @height)
        ]
        super(opts)

    getBoundingBox : () ->
        @vertices

#
# A circle element.
#

class wolf.Circle extends wolf.Element

    @key : "wolf.Circle",

    constructor : (opts) ->
        super(opts)
        @radius = opts.radius

    render : (context) ->
        context.beginPath()
        context.arc(@x, @y, @radius, 0, Math.PI *2)
        context.fill()

    getBoundingBox : () ->
        # FIXME: need non-axis aligned collisions for this

        yt = @y - @radius
        yb = @y + @radius
        xl = @x - @radius
        xr = @x + @radius

        return [
            new wolf.Point(xl, yt)
            new wolf.Point(xr, yt)
            new wolf.Point(xr, yb)
            new wolf.Point(xl, yb)
        ]


