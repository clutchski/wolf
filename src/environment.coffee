#
# The environment is responsible for applying fundamental forces like time and
# gravity to elements.
#


#= require logger


class wolf.Environment

    # Create a new environment.
    constructor: (opts) ->
        defaults =
            density : 10
            gravitationalConstant : 3
            width : 800
            height : 600

        ((@[k] = v) for k, v of wolf.defaults(opts, defaults))
            
        #FIXME: add arguments for gravity and whatnot.
        @logger = new wolf.Logger("wolf.Environment")
        @logger.debug("Initializing")

    # Return true if the element is contained in the environment's bounds,
    # false otherwise.
    contains : (element) ->
        ib = wolf.isBetween
        return ib(0, @width, element.x) and ib(0, @height, element.y)
        

    # Update the elements with the effects of the given number of milliseconds
    # passing.
    #
    # @param element {Array} the element to update
    # @param milliseconds {Number} the number of ms that have elapsed
    elapse: (elements, milliseconds) ->
        (@applyForces(e, milliseconds) for e in elements when e)
        return this

    # Apply the environment's forces to the element for the given number of
    # milliseconds.
    applyForces : (element, milliseconds) ->
        forces = [
            @getDragForce(element),
            @getGravitationalForce(element)
        ]
        resultant = forces.reduce (t, s) -> t.add(s) # FIXME: not portable.
        element.applyForce(resultant, milliseconds)
 
    # Return the force of drag on the element.
    getDragForce : (element) ->
        # FIXME: this is broken at low speeds, and will in fact return a force
        # that is larger than the element's velocity.
        s = element.speed
        s = if s > 1 then s * s else s
        m = 0.5 * @density * s * element.dragCoefficient
        return element.direction.scale(-m)


    # Return the force of gravity on the given element.
    getGravitationalForce : (element) ->
        return new wolf.Vector(0, @gravitationalConstant)

