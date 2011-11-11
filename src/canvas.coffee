#
# An interface to an HTML5 Canvas element.
#


#= require logger


class timber.Canvas

    # Create a timber canvas object.
    #
    # @param id {String} the id of the page's canvas element.
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

