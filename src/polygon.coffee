#
# Polygons.
#


#= require wolf
#= require element
#= require math



#
# This class represents an arbitrary convex polygon
#
class wolf.Polygon extends wolf.Element

    # Create a polygon. Pass the standard element options, as well as an array
    # of points representing the polygon's vertices. The points are relative to
    # the polygon's position.
    constructor : (opts={}) ->
        defaults =
            fillStyle: "#000"
            vertices: []
        super(wolf.defaults(opts, defaults))

    # Render the polygon on the given canvas context.
    render : (context) ->
        # Initialize canvas colors.
        context.fillStyle = @fillStyle
        # Draw the polygon
        [first, rest...] = @getAbsoluteVertices()
        context.beginPath()
        context.moveTo(first.x, first.y)
        (context.lineTo(v.x, v.y) for v in rest)
        context.lineTo(first.x, first.y)
        context.fill()
        return this

    # Set the polygon's vertices.
    setVertices : (vertices) ->
        @vertices = vertices
        this

    # Return the vertices relative to the points center.
    getVertices : () ->
        return @vertices

    # Return the polygon's absolute vertices.
    getAbsoluteVertices : () ->
        position = @getPosition()
        for v in @vertices
            v.toVector().rotate(@angle).getEndPoint().add(position)

    # Return the point at the geometrical center of the element.
    getCenter : ()  ->
        c = @getAbsoluteVertices().reduce((p, v) ->
            return p.add(v)
        , new wolf.Point(0, 0))
        c.x = c.x / @vertices.length
        c.y = c.y / @vertices.length
        return c

    # Return the element's minimum axis aligned bounding box.
    getBoundingBox : () ->
        return @getAbsoluteVertices()


#
# A rectangle element.
#

class wolf.Rectangle extends wolf.Polygon

    # Create a rectangle element. Rectangles take the same standard parameters
    # as elements, along with two additional paramters, width and height.
    constructor : (opts = {}) ->
        @height = opts.height
        @width = opts.width
        @x = opts.x
        @y = opts.y

        halfWidth = @width/2
        halfHeight = @height/2

        opts.vertices = [
            new wolf.Point(-halfWidth, halfHeight)
            new wolf.Point(halfWidth, halfHeight)
            new wolf.Point(halfWidth, -halfHeight)
            new wolf.Point(-halfWidth, -halfHeight)
        ]
        super(opts)
#
# A circle element.
#

class wolf.Circle extends wolf.Element

    constructor : (opts) ->
        defaults =
            fillStyle: "#000"
        super(opts)
        @radius = opts.radius

    render : (context) ->
        context.beginPath()
        context.fillStyle = @fillStyle
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


