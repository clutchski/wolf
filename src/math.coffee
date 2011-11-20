#
# An assortment of Math functions and classes that power the simulations.
#

# Return true if the value n is contained in the closed interval
# [l, u], false otherwise.
#
# @param l {Number} the interval's lower bound
# @param u {Number} the interval's upper bound
# @return {Boolean}
wolf.isBetween = (l, u, n) ->
    return l <= n and n <= u

# Return a random number between the upper and lower values.
wolf.random = (lower, upper) ->
    return Math.random() * (upper - lower + 1) + lower

# Return true if the given interval intersects, false otherwise.
#
# @param i1 {Array} an interval
# @param i2 {Array} an interval
# @return {Boolean}
wolf.intervalIntersects = (i1, i2) ->

    ib = wolf.isBetween

    return ib(i1[0], i1[1], i2[0]) or
           ib(i1[0], i1[1], i2[1]) or
           ib(i2[0], i2[1], i1[0]) or
           ib(i2[0], i2[1], i1[1])

class wolf.Point

    # Create a point.
    #
    # @param x {Number} the x co-ordinate
    # @param y {Number} the y co-ordinate
    constructor : (x, y) ->
        @x = x
        @y = y

    # Return a copy of this point.
    copy: () ->
        return new wolf.Point(@x, @y)

    # Return true if this point is equal to the given point, false
    # otherwise.
    #
    # @param other {Object} the point to compare against.
    # @return {Boolean}
    equals : (other) ->
        # FIXME: floating point math. What to do here?
        return @x == other.x and @y == other.y

    # Return the point produced by summing this point with the given
    # vector.
    #
    # @param vector {Object}
    # @return {Object} the resultant point
    add : (vector) ->
        return new wolf.Vector(@x + vector.x, @y + vector.y)

    # Return a string representation of the point.
    toString : () ->
        return "wolf.Point(#{@x}, #{@y})"


class wolf.Vector extends wolf.Point

    # Return a unit vector with the same with the same direction
    # as this vector.
    #
    # @return {Object} a normalized vector
    normalize : () ->
        return @copy() if @isZeroVector()
        length = this.getLength()
        return new wolf.Vector(@x/length, @y/length)

    # Return true if this vector is the zero vector, false otherwise.
    isZeroVector : () ->
        return @x == 0 and @y == 0

    # Return a copy of this vector.
    copy: () ->
        return new wolf.Vector(@x, @y)

    # Return a new vector scaled by the given value.
    #
    # @param scalar {Number} the value to scale by
    # @return {Object} the scaled vector.
    scale : (scalar) ->
        return new wolf.Vector(@x*scalar, @y*scalar)

    # Return this vector's length.
    #
    # @return {Number}
    getLength : () ->
        return Math.sqrt(@x*@x + @y*@y)

    # Return the vector sum of this and the other vector.
    #
    # @param {Object} the other vector
    # @return {Object}
    add : (other) ->
        return new wolf.Vector(@x + other.x, @y + other.y)

    # Return the difference of this vector and the other.
    #
    # @param {Object} the other vector
    # @return {Object}
    subtract : (other) ->
        return new wolf.Vector(@x - other.x, @y - other.y)

    # Return the dot product of this vector with the other vector.
    #
    # @param {Object} the other vector.
    # @return {Number}
    dotProduct : (other) ->
        pairs = [[@x, other.x], [@y, other.y]]
        return pairs.reduce((sum, coords) ->
            return sum + coords[0] * coords[1]
        , 0)

    # Return the project of this vector onto the given vector.
    #
    # @param {Object} the vector to project onto.
    # @return {Object} the projected vector.
    project : (other) ->
        b = other.normalize()
        return b.scale(this.dotProduct(b))

    # Return a string representation of the vector.
    toString : () ->
        return "wolf.Vector(#{@x}, #{@y})"

