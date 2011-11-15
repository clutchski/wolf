#
# The environment is responsible for applying fundamental forces like time and
# gravity to elements.
#


#= require logger


class timber.Environment

    # Create a new environment.
    constructor: () ->
        #FIXME: add arguments for gravity and whatnot.

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
            resultant = @resultant(element, milliseconds)
            element.applyForce(resultant, milliseconds)
        # HACK: Don't compile the loop into an expression.
        return this


    # Return the resultant of all environmental forces on the element.
    resultant : (element, milliseconds) ->
        forces = [
            @drag(element),
            @gravity(element)
        ]
        #FIXME: not portable
        return forces.reduce (t, s) -> t.add(s)
 
    # Return the force of drag on the element.
    #
    # @param {Object} the element moving through the environment
    # @return {Object} the drag on the element.
    drag : (element) ->

        # FIXME: this is broken at low speeds, and will in fact return a force
        # that is larger than the element's velocity.

        s = element.speed
        s = if s > 1 then timber.square(s) else s

        m = 0.5 * @density * s * element.dragCoefficient

        return element.direction.scale(-m)


    # Return the force of gravity on the given element.
    #
    # @param element {Object}
    gravity : (element) ->
        # FIXME: technically, we should add drag as well.
        # FIXME: Optimize? Singleton?
        return new timber.Vector(0, @gravitationalConstant)

