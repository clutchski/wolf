#
# Polygons.
#


#= require element
#= require math



#
# This class represents an arbitrary convex polygon
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

    # Render the polygon on the given canvas context.
    render : (context) ->
        [first, rest...] = @vertices
        context.beginPath()
        context.moveTo(first.x, first.y)
        (context.lineTo(v.x, v.y) for v in rest)
        context.lineTo(first.x, first.y)
        context.fill()
        return this

    # Set the polygon's vertices. The first vertex will dictate the element's
    # position.
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

    # Return the point at the geometrical center of the element.
    getCenter : ()  ->
        c = @vertices.reduce((p, v) ->
            return p.add(v)
        , new wolf.Point(0, 0))
        c.x = c.x / @vertices.length
        c.y = c.y / @vertices.length
        return c

    # Rotate the element counter-clockwise by the given number of degrees.
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


