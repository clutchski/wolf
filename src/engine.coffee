#
# The Engine simulates the effects of passing time on the elements, the
# environment and, ultimately, what is rendered on the Canvas.
#


#= require canvas
#= require collision
#= require environment
#= require logger



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
        @timestamp = null  # The timestamp of the last step.
        @continue = true
        @interval = 5      # The # of the milliseconds to sleep between steps.

    # Start the engine's event loop.
    start : () ->
        @continue = true
        @timestamp = new Date()
        @loop()

    # Stop the engine's event loop.
    stop : () ->
        @continue = false
        @timestamp = null

    # Add the given elements to the engine.
    add : (elements...) ->
        @elements.push(element) for element in elements

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
        , @interval
