###
#
#  Timber - An HTML5 Canvas game engine.
#
#  Copyright 2011, Matthew Perpick.
#  Timber is freely distributable under the MIT license.
#
#  https://github.com/clutchski/timber
#
###


# The timber global object.
timber = {}


# Export timber to global scope.
this.timber = timber


#
# Utility functions.
#


timber.square = (n) ->
    return n * n

# Return true if the value n is contained in the closed interval
# [l, u], false otherwise.
#
# @param l {Number} the interval's lower bound
# @param u {Number} the interval's upper bound
# @return {Boolean}
timber.is_between = (l, u, n) ->
    return l <= n and n <= u


#
# The timber logger.
#

class timber.Logger

    # Create a timber logger.
    #
    # @param module {String} an identifier for the logger
    constructor : (module) ->
        @module = module

    # Log a message at the debug level.
    #
    # @param message {String} the message to log.
    debug : (message) ->
        @_write("DEBUG", message)

    # Log a message at the info level.
    #
    # @param message {String} the message to log.
    info : (message) ->
        @_write("INFO", message)

    _write : (level, message) ->
        console.log([level, @module, message].join(" | ")) if console



#
# The timber canvas.
#

class timber.Canvas

    # Create a timber canvas object.
    #
    # @param id: the id of the Canvas element.
    constructor : (id) ->
        @logger = new timber.Logger("timber.Canvas")
        @logger.debug("creating canvas with id #{id}")
        @id = id

        # Set-up the canvas.
        @canvas = document.getElementById(@id)
        throw new Error("No element with id: #{id}") if not @canvas

        @context = @canvas.getContext("2d")
        throw new Error("no context") if not @context

    # Render the given elements on the canvas.
    #
    # @param elements {Array} an array of elements to render.
    render: (elements) ->
        (e.render(@context) for e in elements)


    # Clear the canvas.
    clear: () ->
        @context.clearRect(0, 0, @canvas.width, @canvas.height)


class timber.Point

    # Create a point.
    #
    # @param x {Number} the x co-ordinate
    # @param y {Number} the y co-ordinate
    constructor : (x, y) ->
        @x = x
        @y = y

    # Return a copy of this point.
    copy: () ->
        return new timber.Point(@x, @y)

    # Return true if this point is equal to the given point, false
    # otherwise.
    #
    # @param other {Object} the point to compare against.
    # @return {Boolean}
    equals : (other) ->
        # FIXME: floating point math. What to do here?
        return @x == other.x and @y == other.y

    # Return the point produced by summing this point with the given
    # vector.
    #
    # @param vector {Object}
    # @return {Object} the resultant point
    sum : (vector) ->
        return new timber.Vector(@x + vector.x, @y + vector.y)

    # Return a string representation of the point.
    toString : () ->
        return "timber.Point(#{@x}, #{@y})"


class timber.Vector extends timber.Point

    # Return a unit vector with the same with the same direction
    # as this vector.
    #
    # @return {Object} a normalized vector
    normalize : () ->
        if @x == 0 and @y == 0
            return new timber.Vector(0, 0)
        length = this.getLength()
        return new timber.Vector(@x/length, @y/length)

    # Return a new vector scaled by the given value.
    #
    # @param scalar {Number} the value to scale by
    # @return {Object} the scaled vector.
    scale : (scalar) ->
        return new timber.Vector(@x*scalar, @y*scalar)

    # Return this vector's length.
    #
    # @return {Number}
    getLength : () ->
        return Math.sqrt(@x*@x + @y*@y)

    # Return the vector sum of this and the other vector.
    #
    # @param {Object} the other vector
    # @return {Object}
    sum : (other) ->
        return new timber.Vector(@x + other.x, @y + other.y)

    # Return the difference of this vector and the other.
    #
    # @param {Object} the other vector
    # @return {Object}
    subtract : (other) ->
        return new timber.Vector(@x - other.x, @y - other.y)

    # Return the dot product of this vector with the other vector.
    #
    # @param {Object} the other vector.
    # @return {Number}
    dotProduct : (other) ->
        pairs = [[@x, other.x], [@y, other.y]]
        return pairs.reduce((sum, coords) ->
            return sum + coords[0] * coords[1]
        , 0)

    # Return the project of this vector onto the given vector.
    #
    # @param {Object} the vector to project onto.
    # @return {Object} the projected vector.
    project : (other) ->
        b = other.normalize()
        return b.scale(this.dotProduct(b))

    # Return a string representation of the vector.
    toString : () ->
        return "timber.Vector(#{@x}, #{@y})"



#
# The environment is responsible for applying fundamental forces like time and
# gravity to elements.
#
class timber.Environment

    # Create a new environment.
    constructor: () ->
        @logger = new timber.Logger("timber.Environment")
        @logger.debug("Initializing")

        @density = 10              # The density of the environment's medium.
        @gravitationalConstant = 3 # The strength of the environment's gravity.


    # Update the elements with the effects of the given number of milliseconds
    # passing.
    #
    # @param element {Array} the element to update
    # @param milliseconds {Number} the number of ms that have elapsed
    elapse: (elements, milliseconds) ->

        for element in elements

            # Find the net force on the element.
            forces = [
                @drag(element),
                @gravity(element)
            ]
            resultant = forces.reduce (t, s) -> t.sum(s)    #FIXME: not portable

            # Calculate the effect of the forces on the element.
            acceleration = resultant.scale(element.getInverseMass())
            velocity = element.getVelocity().sum(acceleration.scale(milliseconds))
            displacement = velocity.scale(milliseconds)
            position = element.position.sum(displacement)

            # Update the element.
            element.position = position
            element.speed = velocity.getLength()
            element.direction = velocity.normalize()


    # Return the force of drag on the element.
    #
    # @param {Object} the element moving through the environment
    # @return {Object} the drag on the element.
    drag : (element) ->

        # FIXME: this is broken at low speeds, and will in fact return a force
        # that is larger than the element's velocity.

        s = element.speed
        s = if s > 1 then timber.square(s) else s

        m = 0.5 * @density * s *
                             element.dragCoefficient *
                             element.area

        return element.direction.scale(-m)


    # Return the force of gravity on the given element.
    #
    # @param element {Object}
    gravity : (element) ->
        # FIXME: technically, we should add drag as well.
        return new timber.Vector(0, @gravitationalConstant)

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
    #
    applyImpulse : (impulse) ->
        velocity = @getVelocity().sum(impulse)
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

        interval_intersects = (i1, i2) ->
            # FIXME: not portable
            i2.some (p) ->
                timber.is_between(i1[0], i1[1], p)

        return interval_intersects(ty, oy) and interval_intersects(tx, ox)


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

    # Return the collision's concact normal vector, relative
    # to the first element in the collision.
    #
    # @return {Object}
    getContactNormal : () ->
        return @getRelativeVelocity().normalize()
        
    # Return the seperating velocity of the two elements.
    #
    # @return {Number}
    getSeperatingVelocity : () ->
        return @getRelativeVelocity().dotProduct(@getContactNormal())

    getRelativeVelocity : () ->
        return @element1.getVelocity().subtract(@element2.getVelocity())

    # Return the co-efficient of restitution for the given collision.
    # 
    # @return {Number}
    getRestitutionCoefficient : () ->
        #FIXME: implement me
        return 0.5

    getMass : () ->
        return @element1.mass + @element2.mass



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
        if e1.intersects(e2) then new timber.Collision(e1, e2) else null

    # Resolve the given collision.
    # 
    # @param {collision} the collision to resolve.
    resolveCollision : (collision) ->
      
        # Calcule the seperating velocity of the elements.
        seperatingVelocity = collision.getSeperatingVelocity()

        #return if 0 < seperatingVelocity

        # Change the direction and scale by the elasticity of the objects.
        velocity = -seperatingVelocity * collision.getRestitutionCoefficient()

        magnitude = velocity * collision.getMass()
        impulse = collision.getContactNormal().scale(magnitude)

        # Apply the force of the collision to each element in proportion to
        # their mass.
        impulse1 = impulse.scale(collision.element1.getInverseMass())
        collision.element1.applyImpulse(impulse1)

        # The impulse direction is relative to the first element, so flip that 
        # here.
        impulse2 = impulse.scale(-1 * collision.element2.getInverseMass())
        collision.element2.applyImpulse(impulse2)


class timber.Engine

    # Create an engine instance.
    #
    # @param canvasId {String} the id of the canvas element.
    constructor : (canvasId) ->
        @logger = new timber.Logger("timber.Engine")
        @canvas = new timber.Canvas(canvasId)
        @environment = new timber.Environment()
        @collisionHandler = new timber.CollisionHandler()

        @elements = []
        @timestamp = null
        @continue = true

    # Start the engine's event loop.
    start : () ->
        @continue = true
        @timestamp = new Date()
        @loop()

    # Stop the engine's event loop.
    stop : () ->
        @continue = false
        @timestamp = null

    # Add given element to the engine.
    #
    # @param element {Object} the element to be added
    add : (element) ->
        @elements.push(element)

    # Run the engine's event loop.
    loop : () ->
        # Stop, if so desired.
        return if not @continue

        # Determine how much time has elapsed since the last loop.
        now = new Date()
        elapsed = now - @timestamp

        # Update the state of the world.
        @collisionHandler.elapse(@elements, elapsed)
        @environment.elapse(@elements, elapsed)

        # Update the canvas.
        @canvas.clear()
        @canvas.render(@elements)

        # Do it again when the stack clears.
        @timestamp = now
        setTimeout () =>
            @.loop()
        , 0
