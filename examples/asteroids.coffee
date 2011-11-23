#
# A version of Asteroids written in Wolf.
#


# The ship piloted by the player.
class Ship extends wolf.Polygon

    @key : 'Ship'

    constructor : (opts = {}) ->
        shape  = [[0, 0], [-15, -35], [-30, 0]]
        opts.vertices = (new wolf.Point(a+opts.x, b+opts.y) for [a, b] in shape)
        super(opts)

    # Return a bullet fired by the ship.
    shootBullet : () ->
        c = @getCenter()
        bullet = new Bullet(
            x: c.x
            y: c.y - 30,
            direction: @direction.copy()
        )

    # Apply the shift's thrusters.
    thrust : () ->
        impulse = @direction.scale(0.5)
        @applyImpulse(impulse)

    # Turn the ship to the starboard side.
    starboard : () ->
        @turn(-15)

    # Turn the ship to the port side.
    port : () ->
        @turn(15)

    # Turn the ship by the given number of degrees.
    turn : (degrees) ->
        @rotate(degrees)
        @direction = @direction.rotate(degrees)


# Asteroids floating around space.
class Asteroid extends wolf.Circle

    @key : 'Asteroid'

    constructor : (opts = {}) ->
        defaults =
            x: wolf.random(0, 800)
            y: wolf.random(0, 600)
            radius: 10
            speed: 0.2
            direction: new wolf.Vector(wolf.random(-1, 1), wolf.random(-1, 1))
            dragCoefficient: 0

        opts = wolf.defaults(opts, defaults)
        super(opts)

# Enemy ships trying to kill you.
class EnemyShip extends Ship

    @key : 'EnemyShip'

    constructor : (opts = {}) ->
        opts.height = 20
        opts.width = 20
        super(opts)

# Bullets kill things!
class Bullet extends wolf.Circle

    @key : 'Bullet'

    constructor : (opts={}) ->
        opts.radius = 5
        opts.speed = 1.5
        opts.dragCoefficient = 0
        super(opts)


# Create the engine.
engine = new wolf.Engine("example")
engine.environment.gravitationalConstant = 0 # Since this an overhead 2d game.

# Create the plane.
ship = new Ship({x: 200, y:200, speed:0.01, direction: new wolf.Vector(0, -1)})
engine.add(ship)


# Map key presses to behaviours.
commands =
    107 : () ->
        ship.thrust()
    106 : () ->
        ship.starboard()
    108 : () ->
        ship.port()
    32 : () ->
        bullet = ship.shootBullet()
        engine.add(bullet)
    80 : () ->
        engine.logStatusReport()


# Attach behaviours.
$(document).keypress (event) ->
    key = event.which || event.keyCode
    console.log(key)

    callback = commands[key]
    callback() if callback

# Export start and stop to global scope.
this.asteroids =

    run : () ->
        engine.start()


