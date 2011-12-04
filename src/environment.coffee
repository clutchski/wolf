#
# The environment is responsible for applying fundamental forces like time and
# gravity to elements.
#


#= require wolf
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

    # Return true if the element is contained in the environment's bounds,
    # false otherwise.
    contains : (element) ->
        return 0 <= element.x <= @width and
               0 <= element.y <= @height

    # Update the elements with the effects of the given number of milliseconds
    # passing.
    elapse: (elements, milliseconds) ->
        (@elapseElement(e, milliseconds) for e in elements when e)
        return this

    # Update the element with the effects of the number of milliseconds passing
    # in the environment.
    elapseElement : (element, milliseconds) ->
        # Add the environmental forces.
        drag = @getDragForce(element)
        gravity = @getGravitationalForce()
        element.addForces(drag, gravity)
        # Pass the time.
        element.elapse(milliseconds)

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

