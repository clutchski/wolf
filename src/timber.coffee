#
# Timber is a javascript game engine.
#


timber = {}

# Export timber to global scope.

root = this
root.timber = timber


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

    # Return true if this point is equal to the given point, false
    # otherwise.
    #
    # @param other {Object} the point to compare against.
    # @return {Boolean}
    equals : (other) ->
        # FIXME: floating point math. What to do here?
        return @x == other.x and @y == other.y


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

    # Return this vector's length.
    #
    # @return {Number}
    length : () ->
        return Math.sqrt(@x*@x + @y*@y)

# 
# the timber Element. An abstract base class for any drawable thing.
#

class timber.Element

    # Create an element.
    #
    # @param position {Object} a timber.Point 
    # @param direction {Object} 
    # @param direction {Number} the speed of the object in pixels per millisecods
    constructor : (position, direction, speed) ->
        @position = position
        @direction = direction
        @speed = speed



    # Render the element on the given canvas context.
    #
    # @param context {Object} the HTML5 canvas context
    render : (context) ->
        throw new Error("Not Implemented error")
    

#class timber.Circle extends timber.Element
#
#    # Create a circle element.
#    #
#    # @param x {Number} the x offset of the circle's center
#    # @param y {Number} the y offset of the circle's center
#    constructor : (x, y, radius) ->
#        @logger = new timber.Logger("timber.Circle")
#        @x = x
#        @y = y
#        @radius = radius
#
#    render : (context) ->
#        @logger.info("Rendering")
#        context.beginPath()
#        context.arc(@x, @y, @radius, 0, Math.PI * 2)
#        context.stroke()
#        
#
