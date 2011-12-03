#
# An interface to an HTML5 Canvas element.
#

#= require wolf
#= require logger


class wolf.Canvas

    # Create a canvas linked to the canvas element with the given
    # DOM id.
    constructor : (id) ->
        @id = id

        @canvas = document.getElementById(@id)
        throw new Error("No element with id: #{id}") if not @canvas

        @context = @canvas.getContext("2d")
        throw new Error("no context") if not @context

    # Render the given array of elements on the canvas.
    render: (elements) ->
        c = @context
        for e in elements
            c.save()
            e.render(c)
            c.restore()
        this

    # Clear the canvas.
    clear: () ->
        @context.clearRect(0, 0, @canvas.width, @canvas.height)
        this

