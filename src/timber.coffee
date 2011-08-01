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

        @elements = []


    # Add the element to the canvas.
    #
    # @param element {Object} the timber element to add to the canvas
    add: (element) ->
        @elements.push(element)


    # Render the canvas.
    render: () ->
        (e.render(@context) for e in @elements)


# 
# the timber Element. An abstract base class for any drawable thing.
#

class timber.Element

    constructor : () ->


    # Render the element on the given canvas context.
    #
    # @param context {Object} the HTML5 canvas context
    render : (context) ->
        throw new Error("Not Implemented error")
    

class timber.Circle


    
