#
# Timber is a javascript game engine.
#


timber = {}

# Export timber to global scope.

root = this
root.timber = timber


# Throw an assertion error if the given condition is not true.
#
# @param condition {Boolean} the condition to test
# @param message {String} An optional error message
timber.assert = (condition, message='') ->
    # Add in debug mode eventually?
    throw new Error("Assert error #{message}") if condition


#
# The timber logger.
#

class timber.Logger

    # Create a timber logger.
    #
    # @param module {String} an identifier for the logger
    constructor : (module) ->
        @module = module

    _write : (level, message) ->
        console.log("#{@module} | #{level} | #{message}") if console

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
        @context = @canvas.getContext("2d")
        if not @context
            throw new Error("no context")

        @elements = []


    # Add the element to the canvas.
    #
    # @param element {Object} the timber element to add to the canvas
    add: (element) ->
        @elements.push(element)


    # Render the canvas.
    render: () ->
        (e.render(@context) for e in @elements)

 

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
    # @return {Objec} the resultant point
    sum : (vector) ->
        return new timber.Vector(@x + vector.x, @y + vector.y)



class timber.Vector extends timber.Point

    # Return a unit vector with the same with the same direction
    # as this vector.
    #
    # @return {Object} a normalized vector
    normalize : () ->
        if @x == 0 and @y == 0
            throw new Error("the zero vector can't be normalized")
        length = this.length()
        return new timber.Vector(@x/length, @y/length)

    # Return a new vector scaled by the given value.
    #
    # @param scalar {Number} the value to scale by
    scale : (scalar) ->
        return new timber.Vector(@x*scalar, @y*scalar)

    # Return this vector's length.
    #
    # @return {Number}
    length : () ->
        return Math.sqrt(@x*@x + @y*@y)





#
# The environment is responsible for applying fundamental forces like time and
# gravity to elements.
#
class timber.Environment

    constructor: () ->
        @logger = new timber.Logger("timber.Environment")
        @logger.debug("Initializing")

    # Update the element with the effects of the given number of milliseconds
    # passing.
    #
    # @param element {Object} the element to update
    # @param milliseconds {Number} the number of ms that have elapsed
    elapse: (element, milliseconds) ->

        velocity = element.speed * milliseconds
        d = element.direction.scale(velocity)
        element.position = element.position.sum(d)
        return element

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


    # Render the element on the given canvas context.
    #
    # @param context {Object} the HTML5 canvas context
    render : (context) ->
        throw new Error("Not Implemented error")
    


