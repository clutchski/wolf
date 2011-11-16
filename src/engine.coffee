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

        @elements = []     # The list of element's known to the engine.
        @timestamp = null  # The timestamp of the last step.
        @continue = true
        @interval = 5      # The # of the milliseconds to sleep between steps.

    # Start the engine's time simulation.
    start : () ->
        @continue = true
        @timestamp = new Date()
        @step()

    # Stop the engine's time simulation.
    stop : () ->
        @continue = false
        @timestamp = null

    # Add the given elements to the engine.
    add : (elements...) ->
        for element in elements
            @elements.push(element)
            element.bind 'destroyed', (e) =>
                @remove(e)
        return this

    # Remove the given elements from the engine.
    remove : (elements...) ->
        for element in elements
            index = @elements.indexOf(element)
            @elements.splice(index, 1) if index >= 0
        return this

    # Run a single step in the time simulation.
    step : () ->
        # Stop, if so desired.
        return if not @continue

        # Determine how much time has elapsed since the last step.
        now = new Date()
        elapsed = now - @timestamp

        # Update the state of the world.
        @collisionHandler.elapse(@elements, elapsed)
        @environment.elapse(@elements, elapsed)

        # Update the canvas.
        @canvas.clear().render(@elements)

        # Do it again when the stack clears.
        @timestamp = now
        setTimeout () =>
            @.step()
        , @interval
