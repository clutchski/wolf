#
# The Engine simulates the effects of passing time on the elements, the
# environment and, ultimately, what is rendered on the Canvas.
#


#= require canvas
#= require collision
#= require environment
#= require logger


class wolf.Engine

    # Create an engine instance.
    #
    # @param canvasId {String} the id of the canvas element.
    constructor : (canvasId) ->
        @logger = new wolf.Logger("wolf.Engine")
        @canvas = new wolf.Canvas(canvasId)
        @environment = new wolf.Environment()
        @collisionHandler = new wolf.CollisionHandler()

        @elements = []     # The list of element's known to the engine.
        @timestamp = null  # The timestamp of the last step.
        @isRunning = false
        @interval = 5      # The # of the milliseconds to sleep between steps.
        @iteration = 0     # The # of iterations the engine has executed.

    # Start the engine's time simulation.
    start : () ->
        @isRunning = true
        @timestamp = new Date()
        @step()
        return this

    # Stop the engine's time simulation.
    stop : () ->
        @isRunning = false
        @timestamp = null
        return this

    # Start the engine if it's stopped, stop it if it's running.
    toggle : () ->
        if @isRunning then @stop() else @start()
        return this

    # Add the given elements to the engine.
    add : (elements...) ->
        for element in elements
            @elements.push(element)
            element.bind 'destroyed', (e) =>
                @remove(e)
        return this

    # Remove the given elements from the engine.
    remove : (elements...) ->
        # FIXME: won't scale. O(n)
        for element in elements
            index = @elements.indexOf(element)
            @elements.splice(index, 1) if index >= 0
        return this

    # Log a status report on the engine.
    logStatusReport : () ->
        messages = [
            "Status Report",
            "Is running: #{@isRunning}",
            "Iteration: #{@iteration}",
            "Num Elements: #{@elements.length}"
        ]
        (@logger.info(m) for m in messages)
        this

    # Run a single step in the time simulation.
    step : () ->
        # Stop, if so desired.
        return if not @isRunning

        # Update the iteration count.
        @iteration += 1

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
