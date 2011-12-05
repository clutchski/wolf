#
# An assortment of Math functions and classes that power the simulations.
#


#= require wolf


# Return a random number between the upper and lower values.
wolf.random = (lower, upper) ->
    return Math.random() * (upper - lower + 1) + lower

# Return a random element of the array.
wolf.randomElement = (array) ->
    i = Math.floor(Math.random()*array.length)
    return array[i]

# Return true if the given numbers are almost equal.
wolf.almostEqual = (n1, n2, epsilon) ->
    return n1 - n2 < epsilon


# Return true if the given interval intersects, false otherwise.
wolf.intervalIntersects = (i1, i2) ->

    [i10, i11] = i1
    [i20, i21] = i2

    return i10 <= i20 <= i11 or
           i10 <= i21 <= i11 or
           i20 <= i10 <= i21 or
           i20 <= i11 <= i21


class wolf.Point

    # Create a point.
    constructor : (x, y) ->
        @x = x
        @y = y

    # Return a copy of this point.
    copy: () ->
        return new wolf.Point(@x, @y)

    # Return true if this point is equal to the given point, false
    # otherwise.
    equals : (other) ->
        # FIXME: floating point math. What to do here?
        return @x == other.x and @y == other.y

    # Return the point produced by summing this point with the given point.
    add : (point) ->
        return new wolf.Point(@x + point.x, @y + point.y)

    # Return the point produced by substracting the other point from
    # this point.
    subtract : (other) ->
        return new wolf.Point(@x - other.x, @y - other.y)

    # Return true if the point is the origin, otherwise false.
    isOrigin : () ->
        return @x == 0 and @y == 0

    # Return a vector from the origin to this point.
    toVector : () ->
        return new wolf.Vector(@x, @y)

    # Return a string representation of the point.
    toString : () ->
        return "wolf.Point(#{@x}, #{@y})"


class wolf.Vector extends wolf.Point

    # Return a unit vector with the same with the same direction
    # as this vector.
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
    scale : (scalar) ->
        return new wolf.Vector(@x*scalar, @y*scalar)

    # Return this vector's length.
    getLength : () ->
        return Math.sqrt(@x*@x + @y*@y)

    # Return the vector sum of this and the other vector.
    add : (other) ->
        return new wolf.Vector(@x + other.x, @y + other.y)

    # Return the difference of this vector and the other.
    subtract : (other) ->
        return new wolf.Vector(@x - other.x, @y - other.y)

    # Return the dot product of this vector with the other vector.
    dotProduct : (other) ->
        pairs = [[@x, other.x], [@y, other.y]]
        return pairs.reduce((sum, coords) ->
            return sum + coords[0] * coords[1]
        , 0)

    # Return the projection of this vector onto the given vector.
    project : (other) ->
        b = other.normalize()
        return b.scale(this.dotProduct(b))

    # Return the vector created by rotating this vector by the given angle
    # in degrees.
    rotate : (degrees) ->
        r = degrees * Math.PI / 180
        # By rights, this should be matrix multiplication, but we
        # can hack this here.
        cosr = Math.cos(r)
        sinr = Math.sin(r)
        return new wolf.Vector(@x*cosr - @y*sinr, @x*sinr + @y*cosr)

    # Return the angle between this vector and the given vector in radians.
    angle : (other) ->
        ct = @normalize().dotProduct(other.normalize())
        return Math.acos(ct)

    # Return this vector's angle on the unit circle in radians.
    getRotation : () ->
        angle = @angle(new wolf.Vector(1, 0))
        return if @y < 0 then Math.PI * 2 - angle else angle

    # Return the vector's endpoint.
    getEndPoint : () ->
        return new wolf.Point(@x, @y)

    # Return a string representation of the vector.
    toString : () ->
        return "wolf.Vector(#{@x}, #{@y})"

