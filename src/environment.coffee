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

            # Find the net force on the element.
            forces = [
                @drag(element),
                @gravity(element)
            ]
            resultant = forces.reduce (t, s) -> t.add(s)    #FIXME: not portable

            # Calculate the effect of the forces on the element.
            acceleration = resultant.scale(element.getInverseMass())
            velocity = element.getVelocity().add(acceleration.scale(milliseconds))
            displacement = velocity.scale(milliseconds)
            position = element.getPosition().add(displacement)

            # Update the element.
            element.setPosition(position)
            element.speed = velocity.getLength()
            element.direction = velocity.normalize()

        return this # HACK: Don't compile the loop into an expression.

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

